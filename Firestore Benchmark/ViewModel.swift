//
//  ViewModel.swift
//  Firestore Benchmark
//
//  Created by Rodrigo Sol on 14/11/17.
//  Copyright © 2017 Rodrigo Sol. All rights reserved.
//

import Foundation
import Bond

class ViewModel {
    
    var numberOfRecords = Observable<String?>("100")
    var numberOfKeys = Observable<String?>("10")
    var runInParallel = Observable<Bool>(false)
    
    var rtInsertCalls = Observable<String?>("0")
    var rtTimeBeforeFirstInsert = Observable<String?>("0")
    var rtInserted = Observable<String?>("0")
    var rtInsertCallbacks = Observable<String?>("0")
    var rtInsertElapsedTime = Observable<String?>("0")

    var rtGetCalls = Observable<String?>("0")
    var rtTimeBeforeFirstGet = Observable<String?>("0")
    var rtGets = Observable<String?>("0")
    var rtGetCallbacks = Observable<String?>("0")
    var rtGetElapsedTime = Observable<String?>("0")

    var stInsertCalls = Observable<String?>("0")
    var stTimeBeforeFirstInsert = Observable<String?>("0")
    var stInserted = Observable<String?>("0")
    var stInsertCallbacks = Observable<String?>("0")
    var stInsertElapsedTime = Observable<String?>("0")

    var stGetCalls = Observable<String?>("0")
    var stTimeBeforeFirstGet = Observable<String?>("0")
    var stGets = Observable<String?>("0")
    var stGetCallbacks = Observable<String?>("0")
    var stGetElapsedTime = Observable<String?>("0")
}
