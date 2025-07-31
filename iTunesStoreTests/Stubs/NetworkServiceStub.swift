//
//  NetworkServiceStub.swift
//  iTunesStoreTests
//
//  Created by Milou on 7/31/25.
//

import Testing
import RxSwift
@testable import iTunesStore

final class NetworkServiceStub: NetworkServiceInterface {
  
  var stubResult: Any?
  var stubError: Error?
  
  func fetch<T>(endpoint: any APIEndpoint) -> Single<T> where T: Decodable {
    if let error = stubError {
      return Single.error(error)
    }
    
    if let result = stubResult as? T {
      return Single.just(result)
    }
    
    return Single.error(NetworkError.unknown)
  }
}
