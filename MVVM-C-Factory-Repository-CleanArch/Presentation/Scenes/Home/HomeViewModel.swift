//
//  HomeViewModel.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 1.01.2026.
//

import Foundation

enum HomeViewState {
    case loading
    case success
    case failure(String)
}

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    weak var navigationDelegate: HomeNavigationDelegate?
    weak var viewDelegate: HomeViewModelDelegate?
    
    private let repository: HomeRepositoryProtocol
    private var posts = [PostResponse]()
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        fetchData()
    }
    
    func numberOfItems() -> Int {
        return posts.count
    }
    
    func item(at index: Int) -> PostResponse? {
        guard index < posts.count else {
            return nil
        }
        return posts[index]
    }
}

// MARK: -
extension HomeViewModel {
    private func fetchData() {
        viewDelegate?.handleViewModelOutput(state: .loading)
        
        Task {
            
            try? await Task.sleep(nanoseconds:  1 * 1_000_000_000)
            
            let result = await repository.getPosts()
            
            switch result {
            case .success(let response):
                self.posts = response
                viewDelegate?.handleViewModelOutput(state: .success)
            case .failure(let failure):
                viewDelegate?.handleViewModelOutput(state: .failure(failure.localizedDescription))
            }
        }
    }
}
