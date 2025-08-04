//
//  LargeMusicCell.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import SnapKit
import Then
import UIKit

final class LargeMusicCell: UICollectionViewCell {
  
  // MARK: - UI Components
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 8
    $0.layer.masksToBounds = true
  }
  
  private let albumImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let gradientLayer = CAGradientLayer().then {
    $0.colors = [
      UIColor.clear.cgColor,
      UIColor.black.withAlphaComponent(0.2).cgColor,
    ]
    $0.locations = [0.0, 1.0]
  }
  
  private let albumNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .bold)
    $0.textColor = .white
    $0.numberOfLines = 1
  }
  
  private let genreLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .white
    $0.numberOfLines = 1
  }
  
  private let bottomContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let albumIconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
  }
  
  private let trackNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = .black
    $0.numberOfLines = 1
  }
  
  private let artistNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .regular)
    $0.textColor = .gray
    $0.numberOfLines = 1
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = albumImageView.bounds
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.gradientLayer.frame = self.albumImageView.bounds
      
      self.contentView.updateShadowPath()
    }
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    contentView.addSubview(containerView)
    
    contentView.applyShadow(
        estimatedSize: CGSize(width: 300, height: 220)
      )
    
    containerView.addSubview(albumImageView)
    albumImageView.layer.addSublayer(gradientLayer)
    
    containerView.addSubview(albumNameLabel)
    containerView.addSubview(genreLabel)
    containerView.addSubview(bottomContainerView)
    
    bottomContainerView.addSubview(albumIconImageView)
    bottomContainerView.addSubview(trackNameLabel)
    bottomContainerView.addSubview(artistNameLabel)
  }
  
  private func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    albumImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(220)
    }
    
    albumNameLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalTo(genreLabel.snp.top).offset(-4)
    }
    
    genreLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalTo(albumImageView.snp.bottom).offset(-16)
    }
    
    bottomContainerView.snp.makeConstraints {
      $0.top.equalTo(albumImageView.snp.bottom)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    albumIconImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    trackNameLabel.snp.makeConstraints {
      $0.leading.equalTo(albumIconImageView.snp.trailing).offset(12)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalTo(bottomContainerView.snp.centerY).offset(-2)
    }
    
    artistNameLabel.snp.makeConstraints {
      $0.leading.equalTo(albumIconImageView.snp.trailing).offset(12)
      $0.trailing.equalToSuperview().inset(16)
      $0.top.equalTo(bottomContainerView.snp.centerY).offset(2)
    }
  }
  
  // MARK: - Methods
  
  func configure(music: Music) {
    albumImageView.loadLargeImage(from: music.artworkUrl)
    albumNameLabel.text = music.albumName
    genreLabel.text = music.genre
    albumIconImageView.loadImage(from: music.artworkUrl)
    trackNameLabel.text = music.trackName
    artistNameLabel.text = music.artistName
  }
}
