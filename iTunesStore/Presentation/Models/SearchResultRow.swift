//
//  SearchResultRow.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import Foundation

enum SearchResultRow: Hashable {
  case movie(Movie)
  case podcastPair(Podcast, Podcast?)
  
  func hash(into hasher: inout Hasher) {
    switch self {
    case .movie(let movie):
      hasher.combine("movie")
      hasher.combine(movie.id)
      
    case .podcastPair(let first, let second):
      hasher.combine("podcastPair")
      hasher.combine(first.id)
      if let second = second {
        hasher.combine(second.id)
      }
    }
  }
  
  static func == (lhs: SearchResultRow, rhs: SearchResultRow) -> Bool {
    switch (lhs, rhs) {
    case (.movie(let lhsMovie), .movie(let rhsMovie)):
      return lhsMovie.id == rhsMovie.id
      
    case (.podcastPair(let lhsFirst, let lhsSecond), .podcastPair(let rhsFirst, let rhsSecond)):
      return lhsFirst.id == rhsFirst.id && lhsSecond?.id == rhsSecond?.id
      
    default:
      return false
    }
  }
}
