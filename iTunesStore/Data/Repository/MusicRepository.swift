//
//  MusicRepository.swift
//  iTunesStore
//
//  Created by Milou on 7/31/25.
//

import Foundation
import RxSwift

final class MusicRepository: MusicRepositoryInterface {

  private let networkService: NetworkServiceInterface

  init(networkService: NetworkServiceInterface) {
    self.networkService = networkService
  }
  
  func fetchSeasonMusic(season: SeasonType) -> Single<[Music]> {
    let endpoint = iTunesEndpoint.seasonMusic(season: season)

    return networkService.fetch(endpoint: endpoint)
      .map { (response: MusicResponseDTO) in
        response.results.map { $0.toEntity() }
      }
  }
}
