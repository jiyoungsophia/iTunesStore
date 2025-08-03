//
//  AppCoordinator.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import UIKit

final class AppCoordinator {
  private let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    let musicViewReactor = MusicViewReactor()
    let musicViewController = MusicViewController()
    musicViewController.reactor = musicViewReactor

    let navigationController = UINavigationController(
      rootViewController: musicViewController
    )

    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  func showSearchScreen() {
    // 검색 화면 전환 로직
  }
}
