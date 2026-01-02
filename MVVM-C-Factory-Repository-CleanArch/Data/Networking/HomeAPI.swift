//
//  HomeAPI.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import Foundation
import Alamofire

enum HomeAPI: Endpoint {
    case getPosts
    case getPostDetail(id: Int)
    
    
    var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        case .getPostDetail(let id):
            return "/posts/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPosts, .getPostDetail:
                .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPosts, .getPostDetail:
            return nil
        }
    }
}
