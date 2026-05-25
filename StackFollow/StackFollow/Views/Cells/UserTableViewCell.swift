//
//  UserTableViewCell.swift
//  StackFollow
//
//  Created by Mac on 25.05.2026.
//

import UIKit

final class UserTableViewCell: UITableViewCell {
  
  static let identifier = "UserTableViewCell"
  
  private let userImageView = UIImageView()
  private var imageTask: Task<Void, Never>?
  
  private let usernameLabel = UILabel()
  
  private let reputationLabel: UILabel = {
    let label = UILabel()
    
    label.textColor = .brown
    
    return label
  }()
  
  private let mainStackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    
    return stackView
  }()
  
  private let userInfoStackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.alignment = .center
    
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageTask?.cancel()
    imageTask = nil
    userImageView.image = nil
  }
  
  private func setupUI() {
    setupMainStackView()
    setupImageView()
    setupUserInfo()
  }
  
  func configure(with viewModel: UserCellViewModel) {
    
    usernameLabel.text = viewModel.name
    reputationLabel.text = viewModel.reputation
    
    imageTask = Task { [weak self] in
      await self?.userImageView.loadImage(from: viewModel.imageURL)
    }
  }
  
  private func setupMainStackView() {
    contentView.addSubview(mainStackView)
    
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
    ])
  }
  
  private func setupImageView() {
    let imageContainerView = UIView()
    mainStackView.addArrangedSubview(imageContainerView)
    imageContainerView.addSubview(userImageView)
    
    userImageView.contentMode = .scaleAspectFit
    userImageView.clipsToBounds = true
    userImageView.layer.cornerRadius = 8
    
    userImageView.translatesAutoresizingMaskIntoConstraints = false
    imageContainerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageContainerView.widthAnchor.constraint(equalToConstant: 60),
      imageContainerView.heightAnchor.constraint(equalToConstant: 60),
      userImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
      userImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
      userImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
      userImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor)
    ])
  }
  
  private func setupUserInfo() {
    mainStackView.addArrangedSubview(userInfoStackView)
    userInfoStackView.addArrangedSubview(usernameLabel)
    userInfoStackView.addArrangedSubview(reputationLabel)
    
    userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
  }
}
