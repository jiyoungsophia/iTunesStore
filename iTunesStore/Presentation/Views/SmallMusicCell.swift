//
//  SmallMusicCell.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import SnapKit
import Then
import UIKit

final class SmallMusicCell: UICollectionViewCell {
  
  // MARK: - UI Components

  private let containerView = UIView().then {
    $0.backgroundColor = .clear
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

  // MARK: - Setup Methods

  private func setupUI() {
    contentView.addSubview(containerView)

    containerView.addSubview(albumIconImageView)
    containerView.addSubview(trackNameLabel)
    containerView.addSubview(artistNameLabel)
  }

  private func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    albumIconImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }

    trackNameLabel.snp.makeConstraints {
      $0.leading.equalTo(albumIconImageView.snp.trailing).offset(12)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalTo(containerView.snp.centerY).offset(-2)
    }

    artistNameLabel.snp.makeConstraints {
      $0.leading.equalTo(albumIconImageView.snp.trailing).offset(12)
      $0.trailing.equalToSuperview().inset(16)
      $0.top.equalTo(containerView.snp.centerY).offset(2)
    }
  }

  // MARK: - Methods

  func configure(music: Music) {
    albumIconImageView.loadImage(from: music.artworkUrl)
    trackNameLabel.text = music.trackName
    artistNameLabel.text = music.artistName
  }
}
