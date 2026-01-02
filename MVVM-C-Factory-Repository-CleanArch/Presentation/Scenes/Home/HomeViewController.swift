//
//  HomeViewController.swift
//  MVVM-C-Factory-Repository-CleanArch
//
//  Created by rico on 1.01.2026.
//

import UIKit

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "MyCell")
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not imp")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.viewDelegate = self
        viewModel.viewDidLoad()
    }
    
    private func setupUI () {
        view.backgroundColor = .lightGray
        title = "Home Screen"
        indicator.color = .green
        view.addSubview(tableView)
        view.addSubview(indicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraint()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: -
extension HomeViewController: HomeViewModelDelegate {
    func handleViewModelOutput(state: HomeViewState) {
        switch state {
        case .loading:
            self.indicator.startAnimating()
            self.tableView.isHidden = true
            
        case .success:
            self.indicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
            
        case .failure(let msg):
            self.indicator.stopAnimating()
            print("Err: \(msg)")
        }
    }
}

// MARK: -
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        if let item = viewModel.item(at: indexPath.row) {
            var content = cell.defaultContentConfiguration()
            content.text = item.title ?? "-"
            content.secondaryText = item.body ?? ""
            content.secondaryTextProperties.numberOfLines = 2
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .darkGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Click: \(indexPath.row)")
    }
}
