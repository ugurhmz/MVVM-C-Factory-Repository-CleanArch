//
//  HomeRepository.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import Foundation

final class HomeRepository: HomeRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPosts() async -> Result<[PostResponse], NetworkError> {
        return await networkService.fetch(HomeAPI.getPosts, type: [PostResponse].self)
    }
}
