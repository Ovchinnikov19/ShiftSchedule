//
//  FirstViewController.swift
//  ShiftSchedule
//
//  Created by Eduard Ovchinnikov on 07/02/2019.
//  Copyright © 2019 Эдуард Овчинников. All rights reserved.
//

import UIKit

class NewScheduleController: UIViewController {
    
    var nameSchedule:String!
    var selectedOption: String!
    var firstShiftDate: String?
    var endScheduleDate: String?
    var nightShift = true
    var dayOffAfter = true
    
    let dateFormatter = DateFormatter()
   
    let infoOptionLegend = "d- day shift, n = night shift, a - day after night shift , o - day off "
    
    let optionsArray = ["1d+1n/1a+1o", "2d/2o"]
    
    @IBOutlet weak var nameScheduleTF: UITextField!
    @IBOutlet weak var optionTF: UITextField!
    @IBOutlet weak var firstShiftTF: UITextField!
    @IBOutlet weak var endScheduleTF: UITextField!
    @IBAction func nightShiftSwitch(_ sender: UISwitch) {
        nightShift = !nightShift
    }
    @IBAction func dayOffAfterSwitch(_ sender: UISwitch) {
        dayOffAfter = !dayOffAfter
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        changeUIElement()
        createToolbar()
    }

    func changeUIElement() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        
        let firstShiftDatePicker = UIDatePicker()
        firstShiftDatePicker.datePickerMode = .date
        
        let endScheduleDataPicker = UIDatePicker()
        endScheduleDataPicker.datePickerMode = .date
        
        optionTF.inputView = elementPicker
        
        firstShiftTF.inputView = firstShiftDatePicker
        endScheduleTF.inputView = endScheduleDataPicker
    }
    
    @IBAction func selectOption(_ sender: UITextField) {
        if optionTF.text?.isEmpty == true {
            optionTF.text = optionsArray[0]
        }
    }
    
    func createToolbar() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        nameScheduleTF.inputAccessoryView = toolbar
        optionTF.inputAccessoryView = toolbar
        firstShiftTF.inputAccessoryView = toolbar
        endScheduleTF.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func dp(_ sender: UITextField) {
        let datePickerView = sender.inputView as! UIDatePicker
        
        if sender.text?.isEmpty == true {
            let currentDate = Date()
            sender.text = dateFormatter.string(from: currentDate)
        }
        
        if sender == firstShiftTF {
            datePickerView.addTarget(self, action: #selector(handleFirstShiftDP(datePicker:)),  for: .valueChanged)
        } else if sender == endScheduleTF {
            if let firstShift = firstShiftTF.text {
                datePickerView.minimumDate = dateFormatter.date(from: firstShift)
            }
            datePickerView.addTarget(self, action: #selector(handleEndScheduleDP(datePicker:)),  for: .valueChanged)
        }
    }
    
    @objc func handleFirstShiftDP(datePicker: UIDatePicker) {
        
        firstShiftTF.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func handleEndScheduleDP(datePicker: UIDatePicker) {

        endScheduleTF.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    @IBAction func generateScheduleTappedButton(_ sender: Any) {
        nameSchedule = nameScheduleTF.text
        selectedOption = optionTF.text
        firstShiftDate = firstShiftTF.text
        endScheduleDate = endScheduleTF.text
        
        let nonSelected = "nonSelected"
        print("Name Schedule: \(nameSchedule ?? nonSelected)")
        print("Selected Option: \(selectedOption ?? nonSelected)")
        print("First Shift Date: \(firstShiftDate ?? nonSelected)")
        print("End Schedule: \(endScheduleDate ?? nonSelected)")
        print("Night Shift: \(nightShift ? "Yes" : "No")")
        print("Day off after night shift: \(dayOffAfter ? "Yes" : "No")")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension NewScheduleController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionsArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = optionsArray[row]
        optionTF.text = selectedOption
    }
}
