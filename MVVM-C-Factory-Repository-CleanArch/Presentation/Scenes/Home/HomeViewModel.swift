//
//  HomeViewModel.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 1.01.2026.
//

import Foundation

enum GeneralViewState {
    case loading
    case success
    case failure(String)
}

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    
    weak var navigationDelegate: HomeNavigationDelegate?
    weak var viewDelegate: HomeViewModelDelegate?
    
    private let repository: PostRepositoryProtocol
    private var posts = [PostResponse]()
    
    init(repository: PostRepositoryProtocol) {
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
    
    func didSelectRow(at index: Int) {
        guard let post = item(at: index) else { return }
        navigationDelegate?.navigateToDetail(postId: post.id)
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
