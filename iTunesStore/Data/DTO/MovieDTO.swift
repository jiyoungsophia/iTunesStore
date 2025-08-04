//
//  MovieDTO.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import Foundation

struct MovieResponseDTO: Decodable {
  let resultCount: Int
  let results: [MovieDTO]
}

struct MovieDTO: Decodable {
  let trackId: Int
  let artistName: String
  let collectionName: String?
  let trackName: String
  let artworkUrl100: String
  let artworkUrl600: String?
  let primaryGenreName: String?
  let releaseDate: String?
  let contentAdvisoryRating: String?
  let longDescription: String?
  
  var artworkUrl: String {
      return artworkUrl600 ?? artworkUrl100
    }
  
  func toEntity() -> Movie {
    return Movie(
      id: trackId,
      artistName: artistName,
      collectionName: collectionName ?? "Unknown Collection",
      trackName: trackName,
      artworkUrl: artworkUrl,
      genre: primaryGenreName,
      releaseDate: releaseDate,
      contentRating: contentAdvisoryRating,
      longDescription: longDescription
    )
  }
}
