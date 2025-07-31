//
//  RepositoryStubs.swift
//  iTunesStoreTests
//
//  Created by Milou on 7/31/25.
//

import Testing
import RxSwift
@testable import iTunesStore

final class MusicRepositoryStub: MusicRepositoryInterface {
    var stubMusics: [Music] = []
    var stubError: Error?
    
    func fetchSeasonMusic(season: SeasonType) -> Single<[Music]> {
        if let error = stubError {
            return Single.error(error)
        }
        return Single.just(stubMusics)
    }
}

final class MovieRepositoryStub: MovieRepositoryInterface {
    var stubMovies: [Movie] = []
    var stubError: Error?
    
    func searchMovies(term: String) -> Single<[Movie]> {
        if let error = stubError {
            return Single.error(error)
        }
        return Single.just(stubMovies)
    }
}

final class PodcastRepositoryStub: PodcastRepositoryInterface {
    var stubPodcasts: [Podcast] = []
    var stubError: Error?
    
    func searchPodcast(term: String) -> Single<[Podcast]> {
        if let error = stubError {
            return Single.error(error)
        }
        return Single.just(stubPodcasts)
    }
}
