//
//  MovieRepositoryInterface.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import RxSwift

protocol MovieRepositoryInterface {
  func searchMovies(term: String) -> Single<[Movie]>
}
