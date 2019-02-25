//
//  FirstViewController.swift
//  ShiftSchedule
//
//  Created by Eduard Ovchinnikov on 07/02/2019.
//  Copyright © 2019 Эдуард Овчинников. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var nameSchedule:String!{
        willSet{
            print("Did set new name Schedule \(newValue ?? "Unknown")")
        }
    }
    
    @IBOutlet weak var nameScheduleTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func generateScheduleTappedButton(_ sender: Any) {
        nameSchedule = nameScheduleTF.text
    }
    
}

