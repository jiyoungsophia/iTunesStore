//
//  MusicRepositoryInterface.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import RxSwift

protocol MusicRepositoryInterface {
  func fetchSeasonMusic(season: SeasonType) -> Single<[Music]>
}
