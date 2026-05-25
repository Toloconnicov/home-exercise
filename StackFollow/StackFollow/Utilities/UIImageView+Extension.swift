//
//  Image+Extension.swift
//  StackFollow
//
//  Created by Mac on 25.05.2026.
//

import UIKit

extension UIImageView {
  func loadImage(from url: URL?)  async {
    
    guard let url = url else {
      self.image = nil
      return
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      DispatchQueue.main.async {
        self.image = UIImage(data: data)
      }
    } catch {
      self.image = nil
    }
  }
}
