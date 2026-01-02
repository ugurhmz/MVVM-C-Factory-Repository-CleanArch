//
//  HomeRepositoryProtocol.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import Foundation

protocol PostRepositoryProtocol {
    func getPosts() async -> Result<[PostResponse], NetworkError>
    func getPostDetail(id: Int) async -> Result<PostResponse, NetworkError>
}
