//
//  MusicSection.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import Foundation

struct MusicSection: Hashable {
  let seasonType: SeasonType
  let musics: [MusicItem]
  
  var title: String {
    switch seasonType {
    case .spring: return "봄 Best"
    case .summer: return "여름"
    case .fall: return "가을"
    case .winter: return "겨울"
    }
  }
  
  var subtitle: String {
    switch seasonType {
    case .spring: return "봄에 어울리는 음악 Best 10"
    case .summer: return "여름에 어울리는 음악"
    case .fall: return "가을에 어울리는 음악"
    case .winter: return "겨울에 어울리는 음악"
    }
  }
  
  var layoutType: CellLayoutType {
    switch seasonType {
    case .spring, .winter:
      return .large
    case .summer, .fall:
      return .small
    }
  }
  
  var sectionIndex: Int {
    switch seasonType {
    case .spring: return 0
    case .summer: return 1
    case .fall: return 2
    case .winter: return 3
    }
  }
}

extension MusicSection {
  func hash(into hasher: inout Hasher) {
    hasher.combine(seasonType)
  }
  
  static func == (lhs: MusicSection, rhs: MusicSection) -> Bool {
    lhs.seasonType == rhs.seasonType
  }
}

struct MusicItem: Hashable {
  let music: Music
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(music.id)
  }
  
  static func == (lhs: MusicItem, rhs: MusicItem) -> Bool {
    return lhs.music.id == rhs.music.id
  }
}

enum CellLayoutType {
  case large   // 1단 큰 셀 (봄, 겨울)
  case small   // 3단 작은 셀 (여름, 가을)
}
