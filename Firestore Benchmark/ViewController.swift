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
    @IBOutlet weak var rtElapsedTime: UILabel!
    
    
    @IBOutlet weak var stInsertsCalls: UILabel!
    @IBOutlet weak var stTimeBeforeFirstInsert: UILabel!
    @IBOutlet weak var stInserted: UILabel!
    @IBOutlet weak var stElapsedTime: UILabel!
    
    
    var model = ViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.numberOfRecords.bidirectionalBind(to: numberOfRecords.reactive.text)
        model.numberOfKeys.bidirectionalBind(to: numberOfKeys.reactive.text)
        model.runInParallel.bidirectionalBind(to: runInParallel.reactive.isOn)
        model.rtInsertCalls.bind(to: rtInsertsCalls.reactive.text)
        model.rtTimeBeforeFirstInsert.bind(to: rtTimeBeforeFirstInsert.reactive.text)
        model.rtInserted.bind(to: rtInserted.reactive.text)
        model.rtElapsedTime.bind(to: rtElapsedTime.reactive.text)

        model.stInsertCalls.bind(to: stInsertsCalls.reactive.text)
        model.stTimeBeforeFirstInsert.bind(to: stTimeBeforeFirstInsert.reactive.text)
        model.stInserted.bind(to: stInserted.reactive.text)
        model.stElapsedTime.bind(to: stElapsedTime.reactive.text)

        

    }

    @IBAction func start(_ sender: UIBarButtonItem) {

        model.rtInsertCalls.value = "0"
        model.rtTimeBeforeFirstInsert.value = "0"
        model.rtInserted.value = "0"
        model.rtCallbacks.value = "0"
        model.rtElapsedTime.value = "0"
        
        model.stInsertCalls.value = "0"
        model.stTimeBeforeFirstInsert.value = "0"
        model.stInserted.value = "0"
        model.stCallbacks.value = "0"
        model.stElapsedTime.value = "0"
        
        let _ = Benchmark(model: model)
    }


}

