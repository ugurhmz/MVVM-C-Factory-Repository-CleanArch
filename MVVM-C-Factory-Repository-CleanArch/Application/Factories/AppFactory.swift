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
}

@MainActor
final class AppFactory: AppFactoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init() {
        self.networkService = NetworkManager()
    }
    
    func makeHomeViewController(coordinator: HomeNavigationDelegate) -> UIViewController {
        let repository = HomeRepository(networkService: networkService)
        let viewModel = HomeViewModel()
        viewModel.navigationDelegate = coordinator
        let controller = HomeViewController(viewModel: viewModel)
        return controller
    }
}
