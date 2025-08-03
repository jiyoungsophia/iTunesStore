//
//  MovieCell.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import SnapKit
import Then
import UIKit

final class MovieCell: UICollectionViewCell {
  
  // MARK: - UI Components
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
  }
  
  private let artworkImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .systemGreen
  }
  
  private let gradientLayer = CAGradientLayer().then {
    $0.colors = [
      UIColor.clear.cgColor,
      UIColor.black.withAlphaComponent(0.8).cgColor,
    ]
    $0.locations = [0.0, 1.0]
  }
  
  private let contentRatingLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .semibold)
    $0.textColor = .white
    $0.textAlignment = .right
    $0.numberOfLines = 1
  }
  
  private let genreLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .white
    $0.numberOfLines = 1
  }
  
  private let collectionNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 22, weight: .bold)
    $0.textColor = .white
    $0.numberOfLines = 2
  }
  
  private let artistNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .medium)
    $0.textColor = .white
    $0.numberOfLines = 1
  }
  
  private let bottomContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let trackNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .bold)
    $0.textColor = .black
    $0.numberOfLines = 1
  }
  
  private let releaseDateLabel = UILabel().then {
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
    gradientLayer.frame = artworkImageView.bounds
    
    // 그림자 업데이트
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.gradientLayer.frame = self.artworkImageView.bounds
      
      self.contentView.layer.shadowPath = UIBezierPath(
        roundedRect: self.containerView.bounds,
        cornerRadius: self.containerView.layer.cornerRadius
      ).cgPath
    }
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    contentView.addSubview(containerView)
    
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.15
    contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
    contentView.layer.shadowRadius = 8
    contentView.layer.masksToBounds = false
    
    containerView.addSubview(artworkImageView)
    artworkImageView.layer.addSublayer(gradientLayer)
    
    containerView.addSubview(contentRatingLabel)
    containerView.addSubview(genreLabel)
    containerView.addSubview(collectionNameLabel)
    containerView.addSubview(artistNameLabel)
    containerView.addSubview(bottomContainerView)
    
    bottomContainerView.addSubview(trackNameLabel)
    bottomContainerView.addSubview(releaseDateLabel)
  }
  
  private func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(440)
    }
    
    artworkImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(340)
    }
    
    contentRatingLabel.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(16)
    }
    
    genreLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalTo(collectionNameLabel.snp.top).offset(-4)
    }
    
    collectionNameLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalTo(artistNameLabel.snp.top).offset(-4)
    }
    
    artistNameLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalTo(artworkImageView.snp.bottom).offset(-16)
    }
    
    bottomContainerView.snp.makeConstraints {
      $0.top.equalTo(artworkImageView.snp.bottom)
      $0.horizontalEdges.bottom.equalToSuperview()
      $0.height.equalTo(80)
    }
    
    trackNameLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.top.equalToSuperview().inset(16)
    }
    
    releaseDateLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.top.equalTo(trackNameLabel.snp.bottom).offset(4)
    }
  }
  
  // MARK: - Methods
  
  func configure(movie: Movie) {
    artworkImageView.loadLargeImage(from: movie.artworkUrl)
    contentRatingLabel.text = movie.contentRating
    genreLabel.text = movie.genre
    collectionNameLabel.text = movie.collectionName
    artistNameLabel.text = movie.artistName
    trackNameLabel.text = movie.trackName
    
    if let releaseDateString = movie.releaseDate {
        // 간단히 앞의 10글자만 사용 (2021-12-25T10:30:00Z → 2021-12-25)
        let displayDate = String(releaseDateString.prefix(10))
        releaseDateLabel.text = displayDate
      } else {
        releaseDateLabel.text = nil
      }
  }
}
