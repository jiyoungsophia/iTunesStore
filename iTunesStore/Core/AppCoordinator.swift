//
//  AppCoordinator.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import UIKit

final class AppCoordinator {
  private let window: UIWindow
  private var navigationController: UINavigationController?

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
     let musicViewReactor = MusicViewReactor()
     let musicViewController = MusicViewController()
     musicViewController.reactor = musicViewReactor
     musicViewController.coordinator = self  

     let navigationController = UINavigationController(
       rootViewController: musicViewController
     )
     
     self.navigationController = navigationController 

     window.rootViewController = navigationController
     window.makeKeyAndVisible()
   }

  func showSearchScreen() {
    let searchViewReactor = SearchViewReactor()
    searchViewReactor.coordinator = self
    
    let searchViewController = SearchViewController()
    searchViewController.reactor = searchViewReactor
    searchViewController.coordinator = self
    
    navigationController?.pushViewController(searchViewController, animated: true)
  }
   
   func goBackToHome() {
     navigationController?.popViewController(animated: true)
   }
  
  // MARK: - Error Handling
  
  func showErrorAlert(_ error: Error, from viewController: UIViewController? = nil) {
    let alert = UIAlertController(
      title: "오류",
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    
    let presentingVC = viewController ?? navigationController?.topViewController
    presentingVC?.present(alert, animated: true)
  }
 }
