//
//  PodcastRepository.swift
//  iTunesStore
//
//  Created by Milou on 7/31/25.
//

import Foundation
import RxSwift

final class PodcastRepository: PodcastRepositoryInterface {

  private let networkService: NetworkServiceInterface

  init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }

  func searchPodcast(term: String) -> Single<[Podcast]> {
    let endpoint = iTunesEndpoint.searchPodcasts(term: term)

    return networkService.fetch(endpoint: endpoint)
      .map { (response: PodcastResponseDTO) in
        response.results.map { $0.toEntity() }
      }
  }
}
