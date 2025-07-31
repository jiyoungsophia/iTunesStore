//
//  RepositoryTests.swift
//  iTunesStoreTests
//
//  Created by Milou on 7/31/25.
//

import Testing
import RxSwift
import RxBlocking
@testable import iTunesStore

@Suite("Repository 테스트")
struct RepositoryTests {
  
  @Test("MusicRepository - 성공적으로 음악 데이터를 가져오는지 테스트")
  func musicRepository_fetchSeasonMusic_성공() throws {
    // Given - Stub 설정
    let networkStub = NetworkServiceStub()
    let repository = MusicRepository(networkService: networkStub)
    
    let mockResponse = MusicResponseDTO(
      resultCount: 2,
      results: [
        MusicDTO(
          trackId: 1,
          artistName: "아티스트1",
          collectionName: "앨범1",
          trackName: "여름",
          artworkUrl100: "url1",
          artworkUrl600: "url1_large",
          primaryGenreName: "케이팝"
        ),
        MusicDTO(
          trackId: 2,
          artistName: "아티스트2",
          collectionName: "앨범2",
          trackName: "수영장",
          artworkUrl100: "url2",
          artworkUrl600: "url2_large",
          primaryGenreName: "가고싶다"
        )
      ]
    )
    
    networkStub.stubResult = mockResponse
    
    // When - 실제 실행
    let musics = try repository.fetchSeasonMusic(season: .spring)
      .toBlocking()
      .single()
    
    // Then - 결과 검증
    #expect(musics.count == 2)
    #expect(musics[0].id == 1)
    #expect(musics[0].artistName == "아티스트1")
    #expect(musics[0].trackName == "여름")
    #expect(musics[1].id == 2)
    #expect(musics[1].artistName == "아티스트2")
    #expect(musics[1].trackName == "수영장")
  }
  
  @Test("MusicRepository - 네트워크 에러 발생시 에러를 올바르게 전파하는지 테스트")
  func musicRepository_fetchSeasonMusic_네트워크에러() {
    // Given
    let networkStub = NetworkServiceStub()
    let repository = MusicRepository(networkService: networkStub)
    
    networkStub.stubError = NetworkError.invalidURL
    
    // When & Then - 에러가 발생하는지 확인
    #expect(throws: NetworkError.self) {
      try repository.fetchSeasonMusic(season: .spring)
        .toBlocking()
        .single()
    }
  }
  
  @Test("MovieRepository - 영화 검색이 성공하는지 테스트")
  func movieRepository_searchMovies_성공() throws {
    // Given
    let networkStub = NetworkServiceStub()
    let repository = MovieRepository(networkService: networkStub)
    
    let mockResponse = MovieResponseDTO(
      resultCount: 1,
      results: [
        MovieDTO(
          trackId: 100,
          artistName: "감독이름",
          collectionName: "영화컬렉션",
          trackName: "테스트영화",
          artworkUrl100: "movie_url",
          artworkUrl600: "movie_url_large",
          primaryGenreName: "액션",
          contentAdvisoryRating: "15세 이상",
          releaseDate: nil
        )
      ]
    )
    
    networkStub.stubResult = mockResponse
    
    // When
    let movies = try repository.searchMovies(term: "테스트")
      .toBlocking()
      .single()
    
    // Then
    #expect(movies.count == 1)
    #expect(movies[0].id == 100)
    #expect(movies[0].trackName == "테스트영화")
    #expect(movies[0].contentRating == "15세 이상")
  }
}
