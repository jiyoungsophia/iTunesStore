//
//  SearchViewReactor.swift
//  iTunesStore
//
//  Created by Milou on 8/3/25.
//

import Dependencies
import ReactorKit
import RxSwift

final class SearchViewReactor: Reactor {

  enum Action {
    case search(String)
    case goBackToHome
  }

  enum Mutation {
    case setSearchResult(SearchResult)
    case setLoading(Bool)
    case showError(Error)
  }

  struct State {
    var searchResult: SearchResult?
    var searchRows: [SearchResultRow] = []
    var isLoading: Bool = false
    @Pulse var errorAlert: Error?

    var searchTerm: String {
      return searchResult?.searchTerm ?? ""
    }

    var hasResults: Bool {
      return searchResult?.isEmpty == false
    }
  }

  @Dependency(\.searchUseCase) private var searchUseCase
  let initialState = State()
  
  var coordinator: AppCoordinator?

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .search(let term):
      return .concat(
        .just(.setLoading(true)),
        searchUseCase.execute(term: term)
          .asObservable()
          .map { searchResult in
            return .setSearchResult(searchResult)
          }
          .catch { error in
            return Observable.just(.showError(error))
          },
        .just(.setLoading(false))
      )
      
    case .goBackToHome:
      coordinator?.goBackToHome()
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case .setSearchResult(let searchResult):
      state.searchResult = searchResult
      state.searchRows = createSearchRows(
        movies: searchResult.movies,
        podcasts: searchResult.podcasts
      )
      
    case .setLoading(let isLoading):
      state.isLoading = isLoading
      
    case .showError(let error):
      state.errorAlert = error
    }
    
    return state
  }
}

extension SearchViewReactor {
  ///  [           Movie1             ]
  ///  [Podcast1] [Podcast2]
  private func createSearchRows(movies: [Movie], podcasts: [Podcast]) -> [SearchResultRow] {
    var rows: [SearchResultRow] = []
    var movieIndex = 0
    var podcastIndex = 0
    
    while movieIndex < movies.count || podcastIndex < podcasts.count {
      // 영화가 있으면 추가
      if movieIndex < movies.count {
        rows.append(.movie(movies[movieIndex]))
        movieIndex += 1
      }
      
      // 팟캐스트 2개씩 묶어서 추가
      if podcastIndex < podcasts.count {
        let first = podcasts[podcastIndex]
        let second = podcastIndex + 1 < podcasts.count ? podcasts[podcastIndex + 1] : nil
        rows.append(.podcastPair(first, second))
        podcastIndex += 2
      }
    }
    
    return rows
  }
}
