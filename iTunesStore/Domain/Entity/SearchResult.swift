//
//  SearchResult.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation

struct SearchResult {
  let movies: [Movie]
  let podcasts: [Podcast]
  let searchTerm: String
}

extension SearchResult {
  var totalCount: Int {
      return movies.count + podcasts.count
  }

  var isEmpty: Bool {
      return movies.isEmpty && podcasts.isEmpty
  }
}
