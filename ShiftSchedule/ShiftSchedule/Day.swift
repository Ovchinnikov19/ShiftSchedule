//
//  Day.swift
//  ShiftSchedule
//
//  Created by Eduard Ovchinnikov on 28/03/2019.
//  Copyright © 2019 Эдуард Овчинников. All rights reserved.
//
import UIKit
import Foundation

struct Day {
    let date: String
    var dayType: DayType
}

enum DayType {
    case dayShift
    case nightShift
    case afterNightShift
    case dayOff
}

let arrayOptionsDayNightTwoDayOff: [DayType] = [.dayShift, .nightShift, .afterNightShift, .dayOff]

let dayShiftColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
let nightShiftColor = #colorLiteral(red: 0.152186758, green: 0.1422448591, blue: 0.1538110723, alpha: 1)
let afterNightShiftColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
let dayOffColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

