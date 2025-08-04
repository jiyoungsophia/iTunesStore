//
//  MediaItem.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation

protocol MediaItem {
  var id: Int { get }
  var mediaType: MediaType { get }
  var artistName: String { get }
  var collectionName: String { get }
  var trackName: String { get }
  var artworkUrl: String { get }
  var genre: String? { get }
  var releaseDate: String? { get }
}
