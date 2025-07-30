//
//  SeasonMusicUseCase.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import RxSwift

protocol SeasonMusicUseCaseInterface {
  func executeAllSeasons() -> Single<[SeasonType: [Music]]>
  func execute(season: SeasonType) -> Single<[Music]>
}

final class SeasonMusicUseCase: SeasonMusicUseCaseInterface {
  
  private let repository: MusicRepositoryInterface
  
  init(repository: MusicRepositoryInterface) {
    self.repository = repository
  }
  
  func execute(season: SeasonType) -> Single<[Music]> {
    return repository.fetchSeasonMusic(season: season)
  }
  
  func executeAllSeasons() -> Single<[SeasonType : [Music]]> {
    let requests = SeasonType.allCases.map { season in
      execute(season: season)
        .map { music in (season, music) } // Single<(SeasonType, [Music])>
        .catch { _ in Single.just((season, [])) } // 실패 시 빈 배열 처리
    }
    
    return Single.zip(requests)
      .map { results in
        Dictionary(uniqueKeysWithValues: results) // [SeasonType: [Music]]
      }
  }
}
