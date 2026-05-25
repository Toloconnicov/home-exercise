//
//  UserCellViewModel.swift
//  StackFollow
//
//  Created by Mac on 25.05.2026.
//

import Foundation

struct UserCellViewModel {
  
  let imageURL: URL?
  let name: String
  let reputation: String
  
  init(imageURL: URL?, name: String, reputation: String) {
    self.imageURL = imageURL
    self.name = name
    self.reputation = reputation
  }
}
