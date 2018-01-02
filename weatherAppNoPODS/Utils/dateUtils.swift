//
//  dateUtils.swift
//  weatherAppNoPODS
//
//  Created by Caludia Carrillo on 12/26/17.
//  Copyright © 2017 Claudia Carrillo. All rights reserved.
//

import Foundation

func getFormattedDate(dateTime: Double) -> String {
  let date = NSDate(timeIntervalSince1970: TimeInterval(dateTime))
  let dateFormatter = DateFormatter()
  
  dateFormatter.dateFormat = "MMMM, dd YYYY"
  
  return dateFormatter.string(from: date as Date)
}

func getDayOfWeek(dateTime: Double) -> String {
  let date = NSDate(timeIntervalSince1970: TimeInterval(dateTime))
  let dateFormatter = DateFormatter()
  let currentWeekDay = Calendar.current.component(.weekday, from: date as Date)
  
  if (currentWeekDay-1 < dateFormatter.weekdaySymbols.count) {
    return dateFormatter.weekdaySymbols[currentWeekDay-1]
  }
  
  return "Not available"
}

func isDateToday(from interval : TimeInterval) -> Bool {
  let calendar = NSCalendar.current
  let date = Date(timeIntervalSince1970: interval)
  if calendar.isDateInToday(date) {
    return true
  }
  return false
}
