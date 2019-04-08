//
//  SecondViewController.swift
//  ShiftSchedule
//
//  Created by Eduard Ovchinnikov on 07/02/2019.
//  Copyright © 2019 Эдуард Овчинников. All rights reserved.
//

import UIKit

//First task: split currentDate from templeryShowDate

class ScheduleTemplete: UIViewController {
    
    var nameSchedule: String!
    
    var currentDay: String!
    var currentMonth: String!
    var currentYear: String!
    
    var temporaryDay: String!
    var temporaryMonth: String!
    var temporaryYear: String!
    
    var temporaryDate: Date!
    
    var arrayDaysInSchedule:[Day]!
    var arrayDaysInMonth:[Day]!
    
    @IBOutlet weak var nameScheduleLabel: UILabel!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var collectionDays: UICollectionView!
    var daysOfTheWeek = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    
    let dateFormatter = DateFormatter()
    
    var firstDayInMonth: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let nameSchedule = nameSchedule {
            nameScheduleLabel.text = nameSchedule
        }
        
        collectionDays.delegate = self
        collectionDays.dataSource = self
        
        let currentDate = getDate(date: Date())
        
        currentDay = String(currentDate[0])
        currentMonth = String(currentDate[1])
        currentYear = String(currentDate[2])
        
        temporaryDay = String(currentDate[0])
        temporaryMonth = String(currentDate[1])
        temporaryYear = String(currentDate[2])
        
        temporaryDate = dateFormatter.date(from: temporaryDay + "/" + temporaryMonth + "/" + temporaryYear)
        
        arrayDaysInMonth = getArrayDaysInMonth()
        
        currentMonthLabel.text = temporaryMonth + " " + temporaryYear
        
        firstDayInMonth = getFirstDayInMonth()!
        
        print(firstDayInMonth!)
    }
    
    func getFirstDayInMonth() -> Int? {
        return dateFormatter.date(from: "01 \(temporaryMonth!) \(temporaryYear!)")!.dayNumberOfWeek()
    }
    
    func getDate(date: Date) -> [String] {
        let currentDateString = dateFormatter.string(from: date)
        return currentDateString.split(separator: "/").compactMap({String($0)})
    }
    
    func getArrayDaysInMonth() -> [Day] {
        let arrayDaysInMonth = arrayDaysInSchedule.filter({$0.date.split(separator: "/")[1] == temporaryMonth})
        return arrayDaysInMonth
    }
    
    func getAmountDaysInMonth(date: Date) -> Int {
        
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
}


//MARK: - Extention CollectionView
extension ScheduleTemplete: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Task: automatically count amount of cells
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
        
        if indexPath.row < daysOfTheWeek.count {
            cell.dayNumber.text = daysOfTheWeek[indexPath.row]
            cell.backgroundColor = nil
        } else if indexPath.row < daysOfTheWeek.count + firstDayInMonth {
            //cell.dayNumber.text = String(17 + indexPath.row)
            cell.backgroundColor = UIColor.darkGray
        } else if indexPath.row < daysOfTheWeek.count + firstDayInMonth + getAmountDaysInMonth(date: temporaryDate) {
            
            let numberDay = indexPath.row - firstDayInMonth - daysOfTheWeek.count + 1
            
//            print("Index Path Row: \(indexPath.row)")
//            print("First Day in Month: \(firstDayInMonth)")
//            print("Days of the week: \(daysOfTheWeek.count)")
            
            cell.dayNumber.text = String(numberDay)
            
            for day in arrayDaysInMonth{
                guard let dayExcist = Int(day.date.split(separator: "/")[0]) else { continue }
                if dayExcist == numberDay {
                    switch day.dayType{
                    case .dayShift:
                        cell.backgroundColor = dayShiftColor
                    case .nightShift:
                        cell.backgroundColor = nightShiftColor
                    case .afterNightShift:
                        cell.backgroundColor = afterNightShiftColor
                    case .dayOff:
                        cell.backgroundColor = dayOffColor
                    }
                }
            }
        } else {
            cell.dayNumber.text = nil
            cell.backgroundColor = nil
        }
        
        return cell
    }
}

//MARK: - Extention Date
extension Date {
    func dayNumberOfWeek() -> Int? {
        let engWeekday = Calendar.current.dateComponents([.weekday], from: self).weekday
        var rusWeekday = 0
        if let engWeekday = engWeekday {
            if engWeekday != 1 {
                rusWeekday = engWeekday - 2
            } else {
                rusWeekday = 6
            }
        }
        return rusWeekday
    }
}
