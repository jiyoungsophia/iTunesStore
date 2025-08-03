//
//  MusicSection.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import Foundation

enum MusicSection: Int, CaseIterable {
  case spring = 0
  case summer = 1
  case fall = 2
  case winter = 3
  
  var seasonType: SeasonType {
    switch self {
    case .spring: return .spring
    case .summer: return .summer
    case .fall: return .fall
    case .winter: return .winter
    }
  }
  
  var title: String {
    switch self {
    case .spring: return "봄 Best"
    case .summer: return "여름"
    case .fall: return "가을"
    case .winter: return "겨울 Best"
    }
  }
  
  var subtitle: String {
    switch self {
    case .spring: return "봄에 어울리는 음악 Best 10"
    case .summer: return "여름에 어울리는 음악"
    case .fall: return "가을에 어울리는 음악"
    case .winter: return "겨울에 어울리는 음악 Best 10"
    }
  }
  
  var layoutType: CellLayoutType {
    switch self {
    case .spring, .winter: return .large
    case .summer, .fall: return .small
    }
  }
  
  var maxItemCount: Int {
    switch self {
    case .spring, .winter: return 10
    case .summer, .fall: return 15
    }
  }
}

struct MusicItem: Hashable {
  let music: Music
  let section: MusicSection
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(music.id)
    hasher.combine(section.rawValue)
  }
  
  static func == (lhs: MusicItem, rhs: MusicItem) -> Bool {
    return lhs.music.id == rhs.music.id && lhs.section == rhs.section
  }
}

enum CellLayoutType {
    case large  // 1단 셀
    case small  // 3단 셀
}
