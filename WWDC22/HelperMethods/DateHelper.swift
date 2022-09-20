//
//  DateHelper.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-09-19.
//

import Foundation

extension Date {
  func dateWithoutTime() -> Date {
    let calendar = Calendar.current
    return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self)) ?? self
  }
  
  func month() -> Int {
    let calendar = Calendar.current
    return calendar.dateComponents([.month], from: self).month ?? -1
  }
  
  func dateByYear() -> Date {
    let calendar = Calendar.current
    return calendar.date(from: calendar.dateComponents([.year], from: self)) ?? self
  }
}
