//
//  SearchUseCase.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import RxSwift

protocol SearchUseCaseInterface {
  func execute(term: String) -> Single<SearchResult>
}

final class SearchUseCase: SearchUseCaseInterface {

  private let movieRepository: MovieRepositoryInterface
  private let podcastRepository: PodcastRepositoryInterface

  init(
    movieRepository: MovieRepositoryInterface,
    podcastRepository: PodcastRepositoryInterface
  ) {
    self.movieRepository = movieRepository
    self.podcastRepository = podcastRepository
  }

  func execute(term: String) -> Single<SearchResult> {
    return Single.zip(
      movieRepository.searchMovies(term: term),
      podcastRepository.searchPodcast(term: term)
    )
    .map { movies, podcasts in
      SearchResult(
        movies: movies,
        podcasts: podcasts,
        searchTerm: term
      )
    }
  }
}
