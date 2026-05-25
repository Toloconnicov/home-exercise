//
//  ViewController.swift
//  StackFollow
//
//  Created by Mac on 23.05.2026.
//

import UIKit

class UsersListViewController: UIViewController {
  
  private let viewModel: UsersListViewModel
  
  private let tableView = UITableView()
  private let loadingIndicator = UIActivityIndicatorView(style: .large)
  
  private lazy var emptyStateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.isHidden = true
    return label
  }()
  
  init(viewModel: UsersListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    
    viewModel.fetchUsers()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(tableView)
    view.addSubview(loadingIndicator)
    setupEmptyStateView()
    
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }
  
  private func setupBinding() {
    
    viewModel.onLoadingTriggered = { [weak self] isLoading in
      guard let self = self else { return }
      
      isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
    }
    
    viewModel.onError = { [weak self] message in
      guard let self = self else { return }
      
      self.emptyStateLabel.isHidden = false
      self.emptyStateLabel.text = message
    }
  }
  
  private func setupEmptyStateView() {
    view.addSubview(emptyStateLabel)
    
    emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
    ])
  }
}
