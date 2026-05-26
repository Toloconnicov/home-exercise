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
    setupTableView()
    
    Task {
      await viewModel.fetchUsers()
    }
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(loadingIndicator)
    setupEmptyStateView()
    
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.register(
      UserTableViewCell.self,
      forCellReuseIdentifier: UserTableViewCell.identifier
    )
    
    view.addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
  }
  
  private func setupBinding() {
    
    viewModel.onUsersUpdated = { [weak self] in
      guard let self = self else { return }
      
      self.emptyStateLabel.isHidden = !self.viewModel.users.isEmpty
      self.tableView.reloadData()
    }
    
    viewModel.onLoadingTriggered = { [weak self] isLoading in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
      }
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

extension UsersListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier,
                                                   for: indexPath) as? UserTableViewCell else {
      return UITableViewCell()
    }
    
    let cellViewModel = viewModel.cellViewModel(at: indexPath.row)
    cell.configure(with: cellViewModel)
    
    cell.onFollowButtonTapped = { [weak self] in
      self?.viewModel.toggleFollow(at: indexPath.row)
    }
    return cell
  }
}

// MARK: - UITableViewDelegate

extension UsersListViewController: UITableViewDelegate {
  
}
