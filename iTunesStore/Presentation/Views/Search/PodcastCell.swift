//
//  PodcastCell.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import SnapKit
import Then
import UIKit

final class PodcastCell: UICollectionViewCell {
  
  // MARK: - UI Components
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
  }
  
  private let artworkImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .systemPurple
  }
  
  private let gradientLayer = CAGradientLayer().then {
    $0.colors = [
      UIColor.clear.cgColor,
      UIColor.black.withAlphaComponent(0.8).cgColor,
    ]
    $0.locations = [0.0, 1.0]
  }
  
  private let genresLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .medium)
    $0.textColor = .white
    $0.numberOfLines = 1
  }
  
  private let collectionNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.textColor = .white
    $0.numberOfLines = 2
  }
  
  private let artistNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .white
    $0.numberOfLines = 1
  }
  
  private let releaseDateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .regular)
    $0.textColor = .white
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
    gradientLayer.frame = artworkImageView.bounds
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.gradientLayer.frame = self.artworkImageView.bounds
      
      self.contentView.updateShadowPath()
    }
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    contentView.addSubview(containerView)
    
    contentView.applyShadow(
        estimatedSize: CGSize(width: 180, height: 248)
      )
    
    containerView.addSubview(artworkImageView)
    artworkImageView.layer.addSublayer(gradientLayer)
    
    containerView.addSubview(genresLabel)
    containerView.addSubview(collectionNameLabel)
    containerView.addSubview(artistNameLabel)
    containerView.addSubview(releaseDateLabel)
  }
  
  private func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(248)
    }
    
    artworkImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    genresLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(12)
      $0.bottom.equalTo(collectionNameLabel.snp.top).offset(-4)
    }
    
    collectionNameLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(12)
      $0.bottom.equalTo(artistNameLabel.snp.top).offset(-4)
    }
    
    artistNameLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(12)
      $0.bottom.equalTo(releaseDateLabel.snp.top).offset(-4)
    }
    
    releaseDateLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(12)
      $0.bottom.equalToSuperview().inset(12)
    }
  }
  
  // MARK: - Methods
  
  func configure(podcast: Podcast) {
    artworkImageView.loadLargeImage(from: podcast.artworkUrl)
    
    genresLabel.text = podcast.genres
      .filter { !$0.contains("팟캐스트") }
      .joined(separator: ", ")
    
    collectionNameLabel.text = podcast.collectionName
    artistNameLabel.text = podcast.artistName
    releaseDateLabel.text = DateHelper.displayDate(from: podcast.releaseDate)
  }
}
