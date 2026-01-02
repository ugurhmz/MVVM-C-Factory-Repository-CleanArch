//
//  HomeRepository.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import Foundation

final class PostRepository: PostRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // GET POSTS
    func getPosts() async -> Result<[PostResponse], NetworkError> {
        return await networkService.fetch(HomeAPI.getPosts, type: [PostResponse].self)
    }
    
    // GET POST DETAIL
    func getPostDetail(id: Int) async -> Result<PostResponse, NetworkError> {
        return await networkService.fetch(HomeAPI.getPostDetail(id: id), type: PostResponse.self)
    }
}
