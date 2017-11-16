//
//  ViewController.swift
//  Firestore Benchmark
//
//  Created by Rodrigo Sol on 14/11/17.
//  Copyright © 2017 Rodrigo Sol. All rights reserved.
//

import UIKit
import Bond

class ViewController: UITableViewController {

    @IBOutlet weak var numberOfRecords: UITextField!
    @IBOutlet weak var numberOfKeys: UITextField!
    @IBOutlet weak var runInParallel: UISwitch!
    
    @IBOutlet weak var rtInsertsCalls: UILabel!
    @IBOutlet weak var rtTimeBeforeFirstInsert: UILabel!
    @IBOutlet weak var rtInserted: UILabel!
    @IBOutlet weak var rtInsertElapsedTime: UILabel!

    @IBOutlet weak var rtGetsCalls: UILabel!
    @IBOutlet weak var rtTimeBeforeFirstGet: UILabel!
    @IBOutlet weak var rtGets: UILabel!
    @IBOutlet weak var rtGetElapsedTime: UILabel!

    
    @IBOutlet weak var stInsertsCalls: UILabel!
    @IBOutlet weak var stTimeBeforeFirstInsert: UILabel!
    @IBOutlet weak var stInserted: UILabel!
    @IBOutlet weak var stInsertElapsedTime: UILabel!

    @IBOutlet weak var stGetsCalls: UILabel!
    @IBOutlet weak var stTimeBeforeFirstGet: UILabel!
    @IBOutlet weak var stGets: UILabel!
    @IBOutlet weak var stGetElapsedTime: UILabel!

    
    var model = ViewModel()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        model.numberOfRecords.bidirectionalBind(to: numberOfRecords.reactive.text)
        model.numberOfKeys.bidirectionalBind(to: numberOfKeys.reactive.text)
        model.runInParallel.bidirectionalBind(to: runInParallel.reactive.isOn)

        model.rtInsertCalls.bind(to: rtInsertsCalls.reactive.text)
        model.rtTimeBeforeFirstInsert.bind(to: rtTimeBeforeFirstInsert.reactive.text)
        model.rtInserted.bind(to: rtInserted.reactive.text)
        model.rtInsertElapsedTime.bind(to: rtInsertElapsedTime.reactive.text)

        model.rtGetCalls.bind(to: rtGetsCalls.reactive.text)
        model.rtTimeBeforeFirstGet.bind(to: rtTimeBeforeFirstGet.reactive.text)
        model.rtGets.bind(to: rtGets.reactive.text)
        model.rtGetElapsedTime.bind(to: rtGetElapsedTime.reactive.text)
        
        model.stInsertCalls.bind(to: stInsertsCalls.reactive.text)
        model.stTimeBeforeFirstInsert.bind(to: stTimeBeforeFirstInsert.reactive.text)
        model.stInserted.bind(to: stInserted.reactive.text)
        model.stInsertElapsedTime.bind(to: stInsertElapsedTime.reactive.text)

        model.stGetCalls.bind(to: stGetsCalls.reactive.text)
        model.stTimeBeforeFirstGet.bind(to: stTimeBeforeFirstGet.reactive.text)
        model.stGets.bind(to: stGets.reactive.text)
        model.stGetElapsedTime.bind(to: stGetElapsedTime.reactive.text)

    }

    @IBAction func start(_ sender: UIBarButtonItem) {

        model.rtInsertCalls.value = "0"
        model.rtTimeBeforeFirstInsert.value = "0"
        model.rtInserted.value = "0"
        model.rtInsertCallbacks.value = "0"
        model.rtInsertElapsedTime.value = "0"
        
        model.rtGetCalls.value = "0"
        model.rtTimeBeforeFirstGet.value = "0"
        model.rtGets.value = "0"
        model.rtGetCallbacks.value = "0"
        model.rtGetElapsedTime.value = "0"

        model.stInsertCalls.value = "0"
        model.stTimeBeforeFirstInsert.value = "0"
        model.stInserted.value = "0"
        model.stInsertCallbacks.value = "0"
        model.stInsertElapsedTime.value = "0"
        
        model.stGetCalls.value = "0"
        model.stTimeBeforeFirstGet.value = "0"
        model.stGets.value = "0"
        model.stGetCallbacks.value = "0"
        model.stGetElapsedTime.value = "0"

        
        let _ = Benchmark(model: model)
    }


}

