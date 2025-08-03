//
//  PodcastCell.swift
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
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    contentView.addSubview(stackView)
    
    stackView.addArrangedSubview(firstPodcastCell)
    stackView.addArrangedSubview(secondPodcastCell)
  }
  
  private func setupConstraints() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
    
    if podcast.genres.count > 2 {
      genresLabel.text = "\(podcast.genres[0]), \(podcast.genres[1])"
    } else {
      genresLabel.text = podcast.genres.joined(separator: ", ")
    }
    
    collectionNameLabel.text = podcast.collectionName
    artistNameLabel.text = podcast.artistName
    
    if let releaseDateString = podcast.releaseDate {
        let displayDate = String(releaseDateString.prefix(10))
        releaseDateLabel.text = displayDate
      } else {
        releaseDateLabel.text = nil
      }
  }
}
