//
//  dateUtils.swift
//  weatherAppNoPODS
//
//  Created by Caludia Carrillo on 12/26/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

extension Date {
  func dateString(withFormat format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    
    return dateFormatter.string(from: self)
  }
  
  var dayOfWeek: String {
    let dateFormatter = DateFormatter()
    let currentWeekDay = Calendar.current.component(.weekday, from: self)
    
    if currentWeekDay-1 > -1 {
      return dateFormatter.weekdaySymbols[currentWeekDay-1]
    }
    
    return "Not available"
  }
  
  var isToday: Bool {
    let calendar = NSCalendar.current
    if calendar.isDateInToday(self) {
      return true
    }
    return false
  }
}
