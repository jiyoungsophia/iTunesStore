//
//  DetailViewController.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class DetailViewController: UIViewController {
  
  // MARK: - Properties
  
  private let mediaItem: MediaItem
  weak var coordinator: AppCoordinator?
  private let disposeBag = DisposeBag()
  
  // MARK: - UI Components
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  private let artworkImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .systemGreen
  }
  
  private let closeButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    $0.tintColor = .black

  }
  
  private let infoContainerView = UIView().then {
    $0.backgroundColor = .systemBackground
  }
  
  private let genreLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .secondaryLabel
  }
  
  private let collectionNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 24, weight: .bold)
    $0.textColor = .label
    $0.numberOfLines = 0
  }
  
  private let contentRatingLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .semibold)
    $0.textColor = .label
  }
  
  private let artistNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .medium)
    $0.textColor = .secondaryLabel
  }
  
  private let trackNameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = .label
    $0.numberOfLines = 0
  }
  
  private let releaseDateLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .regular)
    $0.textColor = .secondaryLabel
  }
  
  private let descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 18, weight: .bold)
    $0.textColor = .secondaryLabel
    $0.numberOfLines = 0
  }
  
  // MARK: - Initializers
  
  init(mediaItem: MediaItem, coordinator: AppCoordinator?) {
    self.mediaItem = mediaItem
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureContent()
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    [artworkImageView, closeButton, infoContainerView]
      .forEach { contentView.addSubview($0) }
    
    [genreLabel, collectionNameLabel, contentRatingLabel,
     artistNameLabel, trackNameLabel, releaseDateLabel, descriptionLabel]
      .forEach { infoContainerView.addSubview($0) }
    
    setupConstraints()
    setupActions()
  }
  
  private func setupConstraints() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.greaterThanOrEqualTo(view.snp.height)
    }
    
    artworkImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(view.snp.height).multipliedBy(0.6)
    }
    
    closeButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.trailing.equalToSuperview().inset(16)
      $0.width.height.equalTo(40)
    }
    
    infoContainerView.snp.makeConstraints {
      $0.top.equalTo(artworkImageView.snp.bottom).offset(-20)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    genreLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    collectionNameLabel.snp.makeConstraints {
      $0.top.equalTo(genreLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    contentRatingLabel.snp.makeConstraints {
      $0.top.equalTo(collectionNameLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    artistNameLabel.snp.makeConstraints {
      $0.top.equalTo(contentRatingLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    trackNameLabel.snp.makeConstraints {
      $0.top.equalTo(artistNameLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    releaseDateLabel.snp.makeConstraints {
      $0.top.equalTo(trackNameLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(releaseDateLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.lessThanOrEqualToSuperview().inset(40)
    }
  }
  
  private func setupActions() {
    closeButton.rx.tap
      .bind(onNext: { [weak self] in
        self?.coordinator?.dismissDetailScreen()
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Configuration
  
  private func configureContent() {
    artworkImageView.loadLargeImage(from: mediaItem.artworkUrl)
    
    genreLabel.text = mediaItem.genre
    collectionNameLabel.text = mediaItem.collectionName
    artistNameLabel.text = mediaItem.artistName
    trackNameLabel.text = mediaItem.trackName
    releaseDateLabel.text = DateHelper.displayDate(from: mediaItem.releaseDate)
    
    configureMediaDetailContent()
  }
  
  private func configureMediaDetailContent() {
    switch mediaItem.mediaType {
    case .music:
      contentRatingLabel.isHidden = true
      
    case .movie:
      if let movie = mediaItem as? Movie {
        contentRatingLabel.text = movie.contentRating
        descriptionLabel.text = movie.longDescription
        contentRatingLabel.isHidden = movie.contentRating?.isEmpty != false
      }
      
    case .podcast:
      if let podcast = mediaItem as? Podcast {
        genreLabel.text = podcast.genres.joined(separator: ", ")
      }
      contentRatingLabel.isHidden = true
    }
  }
}
