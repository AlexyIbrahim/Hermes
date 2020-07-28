//
//  ViewController.swift
//  HermesProject
//
//  Created by Alexy Ibrahim on 7/28/20.
//  Copyright © 2020 Alexy Ibrahim. All rights reserved.
//

import UIKit
import Hermes

class ViewController: UIViewController {

    let string_NotificationName = "POKE_NOTIFICATION"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        Hermes.keepAnEyeOn(notificationStringName: self.string_NotificationName, observer: self, fromObject: nil) { (notification, userInfo) in
            print("notification fired: \(String(describing: userInfo))")
        }
    }

    @IBAction func Listen(_ sender: UIButton) {
    
    }
    
    @IBAction func Send(_ sender: UIButton) {
        MOTG.notify(notificationStringName: self.string_NotificationName, fromObject: nil, userInfo: ["user": "Dog"])
    }

}

