//
//  PodcastRowCell.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import SnapKit
import Then
import UIKit

final class PodcastRowCell: UICollectionViewCell {
  
  // MARK: - UI Components
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 8
  }
  
  private let firstPodcastCell = PodcastCell()
  private let secondPodcastCell = PodcastCell()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.firstPodcastCell.updateShadowPath()
      if !self.secondPodcastCell.isHidden {
        self.secondPodcastCell.updateShadowPath()
      }
    }
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    contentView.addSubview(stackView)
    
    stackView.addArrangedSubview(firstPodcastCell)
    stackView.addArrangedSubview(secondPodcastCell)
  }
  
  private func setupConstraints() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(248)
    }
  }
  
  // MARK: - Configuration
  
  func configure(first: Podcast, second: Podcast?) {
    firstPodcastCell.configure(podcast: first)
    
    if let second = second {
      secondPodcastCell.configure(podcast: second)
      secondPodcastCell.isHidden = false
    } else {
      secondPodcastCell.isHidden = true
    }
  }
}
