//
//  FirstViewController.swift
//  ShiftSchedule
//
//  Created by Eduard Ovchinnikov on 07/02/2019.
//  Copyright © 2019 Эдуард Овчинников. All rights reserved.
//

import UIKit

class NewScheduleController: UIViewController {
    
    var nameSchedule:String?
    var selectedOption: String?
    var firstShiftDate: String?
    var endScheduleDate: String?
    var nightShift = true
    var dayOffAfter = true
    
    var arrayDaysInSchedule:[Day] = []
    
    let dateFormatter = DateFormatter()
   
    let infoOptionLegend = "d- day shift, n = night shift, a - day after night shift , o - day off "
    let optionsArray = ["1d+1n/1a+1o", "2d/2o"]
    var selectOption: [DayType]!
    var indexOption = 0
    
    let calendar = Calendar.current
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
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
            selectOption = arrayOptionsDayNightTwoDayOff
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func dp(_ sender: UITextField) {
        let datePickerView = sender.inputView as! UIDatePicker
        
        if sender == firstShiftTF {
            firstShiftTF.text = dateFormatter.string(from: datePickerView.date)
        } else if sender == endScheduleTF{
            if let firstShiftDate = firstShiftTF.text {
                datePickerView.minimumDate = dateFormatter.date(from: firstShiftDate)
            }
            endScheduleTF.text = dateFormatter.string(from: datePickerView.date)
        }
    }
    
    @IBAction func generateScheduleTappedButton(_ sender: Any) {
        nameSchedule = nameScheduleTF.text
        selectedOption = optionTF.text
        if selectedOption == optionsArray[0]{
            selectOption = arrayOptionsDayNightTwoDayOff
        }
        firstShiftDate = firstShiftTF.text
        endScheduleDate = endScheduleTF.text
        
        guard let nameSchedule = nameSchedule, let selectedOption = selectedOption, let firstShiftDate = firstShiftDate, let endScheduleDate = endScheduleDate else { return }
        
        if !nameSchedule.isEmpty && !selectedOption.isEmpty && !firstShiftDate.isEmpty && !endScheduleDate.isEmpty {
            generateDaysInSchedule(selectOption: selectOption, firstShiftDate: firstShiftDate, endScheduleDate: endScheduleDate)
        } else {
            let alertGeneration = UIAlertController(title: "Attention", message: "Let enter all text field", preferredStyle: .alert)
            alertGeneration.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertGeneration, animated: true, completion: nil)
        }
        
        // func check first Date < end Date
        
        print("Name Schedule: \(nameSchedule )")
        print("Selected Option: \(selectedOption )")
        print("First Shift Date: \(firstShiftDate )")
        print("End Schedule: \(endScheduleDate )")
        print("Night Shift: \(nightShift ? "Yes" : "No")")
        print("Day off after night shift: \(dayOffAfter ? "Yes" : "No")")
        
        performSegue(withIdentifier: "generateSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? ScheduleTemplete else { return }
        dvc.arrayDaysInSchedule = arrayDaysInSchedule
        dvc.nameSchedule = nameSchedule
    }
    
    func generateDaysInSchedule(selectOption: [DayType], firstShiftDate: String, endScheduleDate: String) {
        
        let startDate = dateFormatter.date(from: firstShiftDate)!
        
        var dateToCalculate = startDate
        
        let endDate = dateFormatter.date(from: endScheduleDate)!
        
        while dateToCalculate <= endDate {
            
            if indexOption == selectOption.count {
                indexOption = 0
            }
            
            let date = dateFormatter.string(from: dateToCalculate)
            let dayType = selectOption[indexOption]
            
            let day = Day(date: date, dayType: dayType)
            arrayDaysInSchedule.append(day)
            
            indexOption += 1
            dateToCalculate = calendar.date(byAdding: .day, value: 1, to: dateToCalculate)!
        }
    }
    
    
}
//MARK: - UIPuckerView Protocols
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
        if row == 0 {
            selectOption = arrayOptionsDayNightTwoDayOff
        }
    }
}
