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
    var rtCallbacks = Observable<String?>("0")
    var rtElapsedTime = Observable<String?>("0")

    var stInsertCalls = Observable<String?>("0")
    var stTimeBeforeFirstInsert = Observable<String?>("0")
    var stInserted = Observable<String?>("0")
    var stCallbacks = Observable<String?>("0")
    var stElapsedTime = Observable<String?>("0")

    
}
