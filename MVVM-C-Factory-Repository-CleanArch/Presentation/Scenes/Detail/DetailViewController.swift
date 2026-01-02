//
//  DetailViewController.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 2.01.2026.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModelProtocol
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not imp")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupUI()
        viewModel.viewDelegate = self
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureData() {
        titleLabel.text = "\(viewModel.idText) - \(viewModel.titleText)"
        bodyLabel.text = viewModel.bodyText
    }
}

// MARK: -
extension DetailViewController: ViewStateDelegate {
    func handleViewModelOutput(state: ViewState) {
        switch state {
        case .loading:
            indicator.startAnimating()
            titleLabel.isHidden = true
            bodyLabel.isHidden = true
            
        case .success:
            indicator.stopAnimating()
            titleLabel.isHidden = false
            bodyLabel.isHidden = false
            configureData()
            
        case .failure(let errorMessage):
            indicator.stopAnimating()
            print("Detay err: \(errorMessage)")
        }
    }
}
