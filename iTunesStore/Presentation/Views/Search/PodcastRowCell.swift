//
//  PodcastRowCell.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import SnapKit
import Then
import UIKit
import RxSwift
import RxCocoa

final class PodcastRowCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  var onFirstPodcastTap: ((Podcast) -> Void)?
  var onSecondPodcastTap: ((Podcast) -> Void)?
  
  private var firstPodcast: Podcast?
  private var secondPodcast: Podcast?
  private var disposeBag = DisposeBag()
  
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
    setupTapGestures()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag() // disposeBag 초기화
    firstPodcast = nil
    secondPodcast = nil
    onFirstPodcastTap = nil
    onSecondPodcastTap = nil
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
  
  private func setupTapGestures() {
    let firstTapGesture = UITapGestureRecognizer()
    firstPodcastCell.addGestureRecognizer(firstTapGesture)
    firstPodcastCell.isUserInteractionEnabled = true
    
    let secondTapGesture = UITapGestureRecognizer()
    secondPodcastCell.addGestureRecognizer(secondTapGesture)
    secondPodcastCell.isUserInteractionEnabled = true
    
    firstTapGesture.rx.event
      .bind(onNext: { [weak self] _ in
        guard let self = self,
              let podcast = self.firstPodcast else { return }
        self.onFirstPodcastTap?(podcast)
      })
      .disposed(by: disposeBag)
    
    secondTapGesture.rx.event
      .bind(onNext: { [weak self] _ in
        guard let self = self,
              let podcast = self.secondPodcast else { return }
        self.onSecondPodcastTap?(podcast)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Configuration
  
  func configure(first: Podcast, second: Podcast?) {
    self.firstPodcast = first
    self.secondPodcast = second
    
    firstPodcastCell.configure(podcast: first)
    
    if let second = second {
      secondPodcastCell.configure(podcast: second)
      secondPodcastCell.isHidden = false
    } else {
      secondPodcastCell.isHidden = true
    }
  }
}
