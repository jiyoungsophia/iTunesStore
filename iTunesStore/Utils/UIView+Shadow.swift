//
//  UIView+Shadow.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import UIKit

extension UIView {
  
  func applyShadow(
    color: UIColor = .black,
    opacity: Float = 0.15,
    offset: CGSize = CGSize(width: 0, height: 4),
    radius: CGFloat = 8,
    cornerRadius: CGFloat = 12,
    estimatedSize: CGSize? = nil
  ) {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.shadowRadius = radius
    layer.masksToBounds = false
    
    // 초기 shadowPath 설정
    if let size = estimatedSize {
      layer.shadowPath = UIBezierPath(
        roundedRect: CGRect(origin: .zero, size: size),
        cornerRadius: cornerRadius
      ).cgPath
    }
  }
  
  func updateShadowPath(cornerRadius: CGFloat = 12) {
    layer.shadowPath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: cornerRadius
    ).cgPath
  }
}
