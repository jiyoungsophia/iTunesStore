//
//  PodcastRepositoryInterface.swift
//  iTunesStore
//
//  Created by Milou on 7/30/25.
//

import RxSwift

protocol PodcastRepositoryInterface {
  func searchPodcast(term: String) -> Single<[Podcast]>
}
