//
//  DTOTests.swift
//  iTunesStoreTests
//
//  Created by Milou on 7/31/25.
//

import Testing
@testable import iTunesStore

@Suite
struct DTOTests {
  
  @Test func musicDTO_toEntity_변환_성공() {
    // Given - 테스트 데이터 준비
    let musicDTO = MusicDTO(
      trackId: 12345,
      artistName: "Tame Impala",
      collectionName: "End Of Summer",
      trackName: "End Of Summer",
      artworkUrl100: "https://example.com/100.jpg",
      artworkUrl600: "https://example.com/600.jpg",
      primaryGenreName: "K-Pop"
    )
    
    // When - 변환 실행
    let music = musicDTO.toEntity()
    
    // Then - 결과 검증
    #expect(music.id == 12345)
    #expect(music.artistName == "Tame Impala")
    #expect(music.albumName == "End Of Summer")
    #expect(music.trackName == "End Of Summer")
    #expect(music.artworkUrl == "https://example.com/600.jpg") // 600이 우선
    #expect(music.genre == "K-Pop")
  }
  
  @Test func movieDTO_toEntity_변환_성공() {
    // Given
    let movieDTO = MovieDTO(
      trackId: 67890,
      artistName: "Denis Villeneuve",
      collectionName: "Dune 2-Film Collection",
      trackName: "듄",
      artworkUrl100: "https://example.com/100.jpg",
      artworkUrl600: nil, // nil인 경우
      primaryGenreName: "SF",
      contentAdvisoryRating: "PG-13",
      releaseDate: nil
    )
    
    // When
    let movie = movieDTO.toEntity()
    
    // Then
    #expect(movie.id == 67890)
    #expect(movie.artistName == "Denis Villeneuve")
    #expect(movie.collectionName == "Dune 2-Film Collection")
    #expect(movie.trackName == "듄")
    #expect(movie.artworkUrl == "https://example.com/100.jpg") // 600이 nil이면 100 사용
    #expect(movie.genre == "SF")
    #expect(movie.contentRating == "PG-13")
  }
}
