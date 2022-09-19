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
}
