//
//  Benchmark.swift
//  Firestore Benchmark
//
//  Created by Rodrigo Sol on 14/11/17.
//  Copyright © 2017 Rodrigo Sol. All rights reserved.
//

import Foundation
import Fakery
import Firebase

import CoreFoundation


class Benchmark {
    let firestore = Firestore.firestore()
    
    var model: ViewModel!
    var records: [[String: Any]] = []
    let faker = Faker()
    
    private let rtInsertCallbacksQueue: DispatchQueue = DispatchQueue(label:"rtInsertCallbacksQueue")
    private let stInsertCallbacksQueue: DispatchQueue = DispatchQueue(label:"stInsertCallbacksQueue")
    private let rtGetCallbacksQueue: DispatchQueue = DispatchQueue(label:"rtGetCallbacksQueue")
    private let stGetCallbacksQueue: DispatchQueue = DispatchQueue(label:"stGetCallbacksQueue")

    
    var rtInsertCallbacks = 0
    var stInsertCallbacks = 0
    var rtGetCallbacks = 0
    var stGetCallbacks = 0

    
    init(model: ViewModel) {
        self.model = model
        initializeRecords()
        if model.runInParallel.value {
            startInParallel()
        } else {
            start()
        }
    }
    
    func initializeRecords() {
        for _ in 0..<Int(self.model.numberOfRecords.value!)! {
            var record: [String: Any] = [:]
            for j in 0..<Int(self.model.numberOfKeys.value!)! {
                record[String(describing: j)] = faker.name.name()
            }
            records.append(record)
        }
    }
    
    func startInParallel() {
        testInsertRealTimeDataBase()
        testInsertFirestore()
    }
    
    func start() {
        testInsertRealTimeDataBase()
    }
    
    
    func testInsertFirestore() {
        let ref = firestore.collection("collection")
        var first = true
        
        let stopwatch = Stopwatch(running: true)
        let firstInsert = Stopwatch(running: true)
        for (index, record) in self.records.enumerated() {
            let insertCalls = Int(self.model.stInsertCalls.value!)! + 1
            self.model.stInsertCalls.value = String(describing: insertCalls)
            
            let docRef = ref.document()
            var newRecord = record
            newRecord["stId"] = docRef.documentID
            records[index] = newRecord
            
            docRef.setData(newRecord
                , completion: { (error) in
                    if first {
                        self.model.stTimeBeforeFirstInsert.value = firstInsert.elapsedTimeString()
                        first = false
                    }
                    
                    let inserted = Int(self.model.stInserted.value!)! + 1
                    self.model.stInserted.value = String(describing: inserted)
                    
                    self.stInsertCallbacksQueue.sync {
                        self.stInsertCallbacks += 1
                        
                        
                        if self.stInsertCallbacks == Int(self.model.numberOfRecords.value!) {

                            self.model.stInsertElapsedTime.value = stopwatch.elapsedTimeString()
                            self.testGetFirestore()
                        }
                    }
            })
        }
    }
    
    func testGetFirestore() {
        let ref = firestore.collection("collection")
        var first = true
        
        let stopwatch = Stopwatch(running: true)
        let firstGet = Stopwatch(running: true)
        for record in self.records {
            let getCalls = Int(self.model.stGetCalls.value!)! + 1
            self.model.stGetCalls.value = String(describing: getCalls)
            
            let docRef = ref.document(record["stId"] as! String)
            
            docRef.getDocument(completion: { (documentSnapshot, error) in
                if first {
                    self.model.stTimeBeforeFirstGet.value = firstGet.elapsedTimeString()
                        first = false
                    }
                    
                    let getted = Int(self.model.stGets.value!)! + 1
                    self.model.stGets.value = String(describing: getted)
                    
                    self.stGetCallbacksQueue.sync {
                        self.stGetCallbacks += 1
                        
                        
                        if self.stGetCallbacks == Int(self.model.numberOfRecords.value!) {
                            self.model.stGetElapsedTime.value = stopwatch.elapsedTimeString()
                        }
                    }
            })
        }
    }
    
    func testInsertRealTimeDataBase() {
        
        var first = true
        let ref = Database.database().reference().child("collection")
        let stopwatch = Stopwatch(running: true)
        let firstInsert = Stopwatch(running: true)
        for (index, record) in self.records.enumerated() {
            let recordRef = ref.childByAutoId()
            var newRecord = record
            newRecord["rtId"] = recordRef.key
            records[index] = newRecord
            let insertCalls = Int(self.model.rtInsertCalls.value!)! + 1
            self.model.rtInsertCalls.value = String(describing: insertCalls)
            
            recordRef.setValue(newRecord, withCompletionBlock: { (err, ref) in
                
                
                if first {
                    self.model.rtTimeBeforeFirstInsert.value = firstInsert.elapsedTimeString()
                    first = false
                }
                
                let inserted = Int(self.model.rtInserted.value!)! + 1
                self.model.rtInserted.value = String(describing: inserted)
                
                self.rtInsertCallbacksQueue.sync {
                    self.rtInsertCallbacks += 1
                    if self.rtInsertCallbacks == Int(self.model.numberOfRecords.value!) {
                        
                        
                        self.model.rtInsertElapsedTime.value = stopwatch.elapsedTimeString()
                        
                        self.testGetRealTimeDataBase()

                    }
                }
            })
        }
    }
    
    func testGetRealTimeDataBase() {
        
        var first = true
        let ref = Database.database().reference().child("collection")
        let stopwatch = Stopwatch(running: true)
        let firstGet = Stopwatch(running: true)
        for record in self.records {

            let getCalls = Int(self.model.rtGetCalls.value!)! + 1
            self.model.rtGetCalls.value = String(describing: getCalls)
            
            ref.child(record["rtId"] as! String).observeSingleEvent(of: .value, with: { (snapshot) in
              
                if first {
                    self.model.rtTimeBeforeFirstGet.value = firstGet.elapsedTimeString()
                    first = false
                }
                
                let getted = Int(self.model.rtGets.value!)! + 1
                self.model.rtGets.value = String(describing: getted)
                
                self.rtGetCallbacksQueue.sync {
                    self.rtGetCallbacks += 1
                    if self.rtGetCallbacks == Int(self.model.numberOfRecords.value!) {
                        
                        
                        self.model.rtGetElapsedTime.value = stopwatch.elapsedTimeString()
                        
                        if !self.model.runInParallel.value {
                            self.testInsertFirestore()
                        }
                        
                    }
                }
            })
        }
    }
}
