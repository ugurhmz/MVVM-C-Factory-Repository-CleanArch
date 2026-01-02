//
//  ViewState.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

enum ViewState {
    case loading
    case success
    case failure(String)
}

@MainActor
protocol ViewStateDelegate: AnyObject {
    func handleViewModelOutput(state: ViewState)
}
