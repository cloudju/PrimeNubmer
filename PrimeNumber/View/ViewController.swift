//
//  ViewController.swift
//  PrimeNumber
//
//  Created by 居朝強 on 2020/08/08.
//  Copyright © 2020 Cloud.Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: outlets
    @IBOutlet weak var cpuCaculateBtn: UIButton!
    @IBOutlet weak var gpuCaculateBtn: UIButton!
    
    // MARK: override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func cpuCaculateTouchUpInside(_ sender: UIButton) {
    }
    
    @IBAction func gpuCaculateTouchUpInside(_ sender: UIButton) {
        let caculator = PrimeNumberCaculateMetal.def
        caculator.calculate()
    }
    
    // MARK: methods


}

