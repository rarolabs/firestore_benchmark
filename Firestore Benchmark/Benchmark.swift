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
    
    private let rtCallbacksQueue: DispatchQueue = DispatchQueue(label:"rtCallbacksQueue")
    
    private let stCallbacksQueue: DispatchQueue = DispatchQueue(label:"stCallbacksQueue")
    
    var rtCallbacks = 0
    var stCallbacks = 0
    
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
        testRealTimeDataBase()
        testFirestore()
    }
    
    func start() {
        testRealTimeDataBase()
    }
    
    
    func testFirestore() {
        let ref = firestore.collection("collection")
        var first = true
        
        let stopwatch = Stopwatch(running: true)
        let firstInsert = Stopwatch(running: true)
        for record in self.records {
            let insertCalls = Int(self.model.stInsertCalls.value!)! + 1
            self.model.stInsertCalls.value = String(describing: insertCalls)
            
            ref.addDocument(data: record
                , completion: { (error) in
                    
                    if first {
                        self.model.stTimeBeforeFirstInsert.value = firstInsert.elapsedTimeString()
                        first = false
                    }
                    
                    let inserted = Int(self.model.stInserted.value!)! + 1
                    self.model.stInserted.value = String(describing: inserted)
                    
                    self.stCallbacksQueue.sync {
                        self.stCallbacks += 1
                        
                        
                        if self.stCallbacks == Int(self.model.numberOfRecords.value!) {
                            
                            
                            self.model.stElapsedTime.value = stopwatch.elapsedTimeString()
                            if !self.model.runInParallel.value {
                                self.testFirestore()
                            }
                            
                            print("Fim")
                        }
                    }
            })
        }
    }
    
    
    func testRealTimeDataBase() {
        
        var first = true
        let ref = Database.database().reference().child("collection")
        let stopwatch = Stopwatch(running: true)
        let firstInsert = Stopwatch(running: true)
        for record in self.records {
            let recordRef = ref.childByAutoId()
            
            let insertCalls = Int(self.model.rtInsertCalls.value!)! + 1
            self.model.rtInsertCalls.value = String(describing: insertCalls)
            
            recordRef.setValue(record, withCompletionBlock: { (err, ref) in
                
                if first {
                    self.model.rtTimeBeforeFirstInsert.value = firstInsert.elapsedTimeString()
                    first = false
                }
                
                let inserted = Int(self.model.rtInserted.value!)! + 1
                self.model.rtInserted.value = String(describing: inserted)
                
                self.rtCallbacksQueue.sync {
                    self.rtCallbacks += 1
                    
                    
                    if self.rtCallbacks == Int(self.model.numberOfRecords.value!) {
                        
                        
                        self.model.rtElapsedTime.value = stopwatch.elapsedTimeString()
                        
                        print("Fim")
                    }
                }
            })
        }
    }
}
