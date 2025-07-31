//
//  DependencyKeys.swift
//  iTunesStore
//
//  Created by Milou on 7/31/25.
//

import Dependencies

// MARK: - Network Layer Dependencies

private struct NetworkServiceKey: DependencyKey {
  static let liveValue: NetworkServiceInterface = NetworkService()
//  static let testValue: NetworkServiceInterface = NetworkServiceStub()
}

extension DependencyValues {
  var networkService: NetworkServiceInterface {
    get { self[NetworkServiceKey.self] }
    set { self[NetworkServiceKey.self] = newValue }
  }
}

// MARK: - Repository Layer Dependencies

private struct MusicRepositoryKey: DependencyKey {
  static let liveValue: MusicRepositoryInterface = {
    @Dependency(\.networkService) var networkService
    return MusicRepository(networkService: networkService)
  }()
}

private struct MovieRepositoryKey: DependencyKey {
  static let liveValue: MovieRepositoryInterface = {
    @Dependency(\.networkService) var networkService
    return MovieRepository(networkService: networkService)
  }()
}

private struct PodcastRepositoryKey: DependencyKey {
  static let liveValue: PodcastRepositoryInterface = {
    @Dependency(\.networkService) var networkService
    return PodcastRepository(networkService: networkService)
  }()
}

extension DependencyValues {
  var musicRepository: MusicRepositoryInterface {
    get { self[MusicRepositoryKey.self] }
    set { self[MusicRepositoryKey.self] = newValue }
  }
  
  var movieRepository: MovieRepositoryInterface {
    get { self[MovieRepositoryKey.self] }
    set { self[MovieRepositoryKey.self] = newValue }
  }
  
  var podcastRepository: PodcastRepositoryInterface {
    get { self[PodcastRepositoryKey.self] }
    set { self[PodcastRepositoryKey.self] = newValue }
  }
}

// MARK: - UseCase Layer Dependencies

private struct SeasonMusicUseCaseKey: DependencyKey {
  static let liveValue: SeasonMusicUseCaseInterface = {
    @Dependency(\.musicRepository) var musicRepository
    return SeasonMusicUseCase(repository: musicRepository)
  }()
}

private struct SearchUseCaseKey: DependencyKey {
  static let liveValue: SearchUseCaseInterface = {
    @Dependency(\.movieRepository) var movieRepository
    @Dependency(\.podcastRepository) var podcastRepository
    return SearchUseCase(
      movieRepository: movieRepository,
      podcastRepository: podcastRepository
    )
  }()
}

extension DependencyValues {
  var seasonMusicUseCase: SeasonMusicUseCaseInterface {
    get { self[SeasonMusicUseCaseKey.self] }
    set { self[SeasonMusicUseCaseKey.self] = newValue }
  }
  
  var searchUseCase: SearchUseCaseInterface {
    get { self[SearchUseCaseKey.self] }
    set { self[SearchUseCaseKey.self] = newValue }
  }
}
