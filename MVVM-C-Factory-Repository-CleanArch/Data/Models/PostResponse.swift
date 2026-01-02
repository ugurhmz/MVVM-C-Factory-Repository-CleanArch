//
//  Post.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import Foundation

struct PostResponse: Decodable {
    let id: Int
    let title: String?
    let body: String?
}
