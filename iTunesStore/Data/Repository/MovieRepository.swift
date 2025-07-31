//
//  MovieRepository.swift
//  iTunesStore
//
//  Created by Milou on 7/31/25.
//

import Foundation
import RxSwift

final class MovieRepository: MovieRepositoryInterface {

  private let networkService: NetworkServiceInterface

  init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }

  func searchMovies(term: String) -> Single<[Movie]> {
    let endpoint = iTunesEndpoint.searchMovies(term: term)

    return networkService.fetch(endpoint: endpoint)
      .map { (response: MovieResponseDTO) in
        response.results.map { $0.toEntity() }
      }
  }
}
