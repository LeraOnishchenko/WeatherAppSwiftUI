//
//  Utils.swift
//  combineRx
//
//  Created by lera on 30.08.2023.
//

import Foundation


func formattedDate(from timestamp: Int) -> String {
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "d 'th' MMM `yy"
    return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
 }

func weekdayName(from timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: date)
}

func formattedTime(from timestamp: Int) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH"
      let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
      return dateFormatter.string(from: date)
  }
