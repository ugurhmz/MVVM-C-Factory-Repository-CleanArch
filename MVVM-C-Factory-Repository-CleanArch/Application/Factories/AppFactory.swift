//
//  AppFactory.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 1.01.2026.
//

import UIKit

@MainActor
protocol AppFactoryProtocol {
    func makeHomeViewController(coordinator: HomeNavigationDelegate) -> UIViewController
    func makeDetailViewController(postId: Int) -> UIViewController
}

@MainActor
final class AppFactory: AppFactoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init() {
        self.networkService = NetworkManager()
    }
}

// MARK: - Make some VC
extension AppFactory {
    func makeHomeViewController(coordinator: HomeNavigationDelegate) -> UIViewController {
        let repository = PostRepository(networkService: networkService)
        let viewModel = HomeViewModel(repository: repository)
        viewModel.navigationDelegate = coordinator
        let controller = HomeViewController(viewModel: viewModel)
        return controller
    }
    
    func makeDetailViewController(postId: Int) -> UIViewController {
        let repository = PostRepository(networkService: networkService)
        let viewModel = DetailViewModel(postId: postId, repository: repository)
        let controller = DetailViewController(viewModel: viewModel)
        return controller
    }
}
