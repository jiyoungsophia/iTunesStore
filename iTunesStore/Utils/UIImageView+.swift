//
//  UIImageView+.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import UIKit
import Kingfisher

extension UIImageView {
  
  func loadImage(from url: String, placeholder: UIImage? = nil) {
    kf.setImage(
      with: URL(string: url),
      placeholder: placeholder,
      options: [
        .cacheOriginalImage, // 원본 크기 이미지를 캐시에 저장
      ]
    )
  }
  
  func loadLargeImage(from url: String, placeholder: UIImage? = nil) {
    kf.setImage(
      with: URL(
        string: url
          .replacingOccurrences(of: "100x100bb.jpg", with: "600x600bb.jpg")
      ),
      placeholder: placeholder,
      options: [
        .cacheOriginalImage,
      ]
    )
  }
}
