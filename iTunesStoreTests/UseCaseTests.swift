//
//  UseCaseTests.swift
//  iTunesStoreTests
//
//  Created by Milou on 7/31/25.
//

import Testing
import RxSwift
import RxBlocking
@testable import iTunesStore

@Suite("UseCase 테스트")
struct UseCaseTests {
    
    @Test("SeasonMusicUseCase - 단일 계절 음악 가져오기 성공")
    func seasonMusicUseCase_execute_단일계절_성공() throws {
        // Given
        let repositoryStub = MusicRepositoryStub()
        let useCase = SeasonMusicUseCase(repository: repositoryStub)
        
        let expectedMusics = [
            Music(id: 1, artistName: "봄아티스트", albumName: "봄앨범", trackName: "봄노래", artworkUrl: "url", genre: "케이팝"),
            Music(id: 2, artistName: "봄아티스트2", albumName: "봄앨범2", trackName: "봄노래2", artworkUrl: "url2", genre: "팝")
        ]
        
        repositoryStub.stubMusics = expectedMusics
        
        // When
        let result = try useCase.execute(season: .spring)
            .toBlocking()
            .single()
        
        // Then
        #expect(result.count == 2)
        #expect(result[0].artistName == "봄아티스트")
        #expect(result[1].artistName == "봄아티스트2")
    }
    
    @Test("SeasonMusicUseCase - 모든 계절 음악 가져오기 성공")
    func seasonMusicUseCase_executeAllSeasons_성공() throws {
        // Given
        let repositoryStub = MusicRepositoryStub()
        let useCase = SeasonMusicUseCase(repository: repositoryStub)
        
        let testMusic = Music(id: 1, artistName: "테스트", albumName: "앨범", trackName: "노래", artworkUrl: "url", genre: "팝")
        repositoryStub.stubMusics = [testMusic]
        
        // When
        let result = try useCase.executeAllSeasons()
            .toBlocking()
            .single()
        
        // Then
        #expect(result.keys.count == 4) // 4계절 모두
        #expect(result[.spring]?.count == 1)
        #expect(result[.summer]?.count == 1)
        #expect(result[.fall]?.count == 1)
        #expect(result[.winter]?.count == 1)
        
        #expect(result[.spring]?[0].artistName == "테스트")
    }
    
    @Test("SearchUseCase - 통합 검색 성공")
    func searchUseCase_execute_성공() throws {
        // Given
        let movieRepositoryStub = MovieRepositoryStub()
        let podcastRepositoryStub = PodcastRepositoryStub()
        let useCase = SearchUseCase(
            movieRepository: movieRepositoryStub,
            podcastRepository: podcastRepositoryStub
        )
        
        let expectedMovies = [
            Movie(id: 1, artistName: "감독", collectionName: "컬렉션", trackName: "영화", artworkUrl: "url", genre: "액션", contentRating: nil, releaseDate: nil)
        ]
        
        let expectedPodcasts = [
            Podcast(id: 2, artistName: "팟캐스터", collectionName: "팟캐스트", trackName: "에피소드", artworkUrl: "url", genre: "교육", genres: ["교육"], releaseDate: nil)
        ]
        
        movieRepositoryStub.stubMovies = expectedMovies
        podcastRepositoryStub.stubPodcasts = expectedPodcasts
        
        // When
        let result = try useCase.execute(term: "테스트")
            .toBlocking()
            .single()
        
        // Then
        #expect(result.searchTerm == "테스트")
        #expect(result.movies.count == 1)
        #expect(result.podcasts.count == 1)
        #expect(result.totalCount == 2)
        #expect(result.isEmpty == false)
        
        #expect(result.movies[0].trackName == "영화")
        #expect(result.podcasts[0].trackName == "에피소드")
    }
    
    @Test("SearchUseCase - 빈 검색 결과")
    func searchUseCase_execute_빈결과() throws {
        // Given
        let movieRepositoryStub = MovieRepositoryStub()
        let podcastRepositoryStub = PodcastRepositoryStub()
        let useCase = SearchUseCase(
            movieRepository: movieRepositoryStub,
            podcastRepository: podcastRepositoryStub
        )
        
        // 빈 배열로 설정
        movieRepositoryStub.stubMovies = []
        podcastRepositoryStub.stubPodcasts = []
        
        // When
        let result = try useCase.execute(term: "존재하지않는검색어")
            .toBlocking()
            .single()
        
        // Then
        #expect(result.isEmpty == true)
        #expect(result.totalCount == 0)
    }
}
