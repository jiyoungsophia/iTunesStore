//
//  MusicReactor.swift
//  iTunesStore
//
//  Created by Milou on 7/31/25.
//

import Dependencies
import ReactorKit
import RxSwift

final class MusicViewReactor: Reactor {

  enum Action {
    case loadSeasonMusic
  }

  enum Mutation {
    case setSeasonMusic([SeasonType: [Music]])
    case setLoading(Bool)
    case setError(Error)
  }

  struct State {
    var seasonMusic: [SeasonType: [Music]] = [:]
    var isLoading: Bool = false
    var error: Error?

    var debugInfo: String {
      let totalCount = seasonMusic.values.flatMap { $0 }.count
      return "총 \(totalCount)개 음악 로드됨"
    }
  }

  @Dependency(\.seasonMusicUseCase) private var seasonMusicUseCase
  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadSeasonMusic:
      return .concat(
        .just(.setLoading(true)),
        seasonMusicUseCase.executeAllSeasons()
          .asObservable()
          .map { seasonMusic in
            return .setSeasonMusic(seasonMusic)
          }
          .catch { error in
            return Observable.just(.setError(error))
          },
        .just(.setLoading(false))
      )
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .setSeasonMusic(let seasonMusic):
      state.seasonMusic = seasonMusic
    case .setLoading(let isLoading):
      state.isLoading = isLoading
    case .setError(let error):
      state.error = error
    }

    return state
  }
}
