//
//  DateHelper.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import Foundation

struct DateHelper {
  static func displayDate(from dateString: String?) -> String? {
    return dateString.map { String($0.prefix(10)) }
  }
}
