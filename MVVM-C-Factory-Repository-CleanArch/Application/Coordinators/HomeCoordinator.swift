//
//  HomeCoordinator.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 1.01.2026.
//

import UIKit

@MainActor
final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    private let factory: AppFactoryProtocol
    
    
    init(navigationController: UINavigationController, factory: AppFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let homeVC = factory.makeHomeViewController(coordinator: self)
        navigationController.pushViewController(homeVC, animated: true)
    }
}

// MARK: -
extension HomeCoordinator: HomeNavigationDelegate {
    func navigateToDetail(postId: Int) {
        let detailVC = factory.makeDetailViewController(postId: postId)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
