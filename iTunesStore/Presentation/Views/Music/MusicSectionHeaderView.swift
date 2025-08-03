//
//  MusicSectionHeaderView.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import UIKit
import SnapKit
import Then

class MusicSectionHeaderView: UICollectionReusableView {
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = .label
  }
  
  private let subtitleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .secondaryLabel
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    [titleLabel, subtitleLabel].forEach {
      addSubview($0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(16)
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.lessThanOrEqualToSuperview().inset(8)
    }
  }
  
  // MARK: - Methods
  
  func configure(section: MusicSection) {
    titleLabel.text = section.title
    subtitleLabel.text = section.subtitle
  }
}
