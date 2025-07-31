//
//  NetworkService.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//
import RxSwift

protocol NetworkServiceInterface {
  func fetch<T: Decodable>(endpoint: APIEndpoint) -> Single<T>
}
