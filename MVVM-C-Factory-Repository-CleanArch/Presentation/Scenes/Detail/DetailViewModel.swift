//
//  DetailViewModel.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import Foundation

@MainActor
protocol DetailViewModelProtocol {
    var titleText: String { get }
    var bodyText: String { get }
    var idText: String { get }
    
    var viewDelegate: HomeViewModelDelegate? { get set }
    func viewDidLoad()
}

@MainActor
final class DetailViewModel: DetailViewModelProtocol {
    weak var viewDelegate: HomeViewModelDelegate?
    
    private let repository: PostRepositoryProtocol
    private let postId: Int
    private var post: PostResponse?
    
    init(postId: Int, repository: PostRepositoryProtocol) {
        self.postId = postId
        self.repository = repository
    }
    
    var titleText: String { post?.title ?? "" }
    var bodyText: String { post?.body ?? "" }
    var idText: String { "#\(post?.id ?? 0)" }
    
    func viewDidLoad() {
        fetchDetail()
    }
    
    private func fetchDetail() {
        viewDelegate?.handleViewModelOutput(state: .loading)
        
        Task {
            let result = await repository.getPostDetail(id: postId)
            
            switch result {
            case .success(let response):
                self.post = response
                viewDelegate?.handleViewModelOutput(state: .success)
                
            case .failure(let error):
                viewDelegate?.handleViewModelOutput(state: .failure(error.localizedDescription))
            }
        }
    }
}
