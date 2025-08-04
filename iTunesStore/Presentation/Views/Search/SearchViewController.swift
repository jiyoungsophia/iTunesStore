//
//  SearchViewController.swift
//  iTunesStore
//
//  Created by Milou on 8/4/25.
//

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SearchViewController: UIViewController, View {
  
  // MARK: - UI Components
  
  private let searchTermTitleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 34, weight: .bold)
    $0.textColor = .label
    $0.numberOfLines = 1
    $0.isUserInteractionEnabled = true
    $0.text = "Search"
  }
  
  private let searchBar = UISearchBar().then {
    $0.backgroundColor = .systemBackground
    $0.placeholder = "영화, 팟캐스트"
    $0.searchBarStyle = .minimal
    $0.showsCancelButton = true
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .systemBackground
    $0.showsVerticalScrollIndicator = true
    $0.contentInsetAdjustmentBehavior = .never
  }
  
  private lazy var dataSource = makeDataSource()
  
  private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
    $0.hidesWhenStopped = true
  }
  
  private let emptyStateView = UIView().then {
    $0.backgroundColor = .systemBackground
    $0.isHidden = true
  }
  
  private let emptyLabel = UILabel().then {
    $0.text = "검색 결과가 없습니다"
    $0.font = .systemFont(ofSize: 18, weight: .medium)
    $0.textColor = .secondaryLabel
    $0.textAlignment = .center
  }
  
  private let initialStateView = UIView().then {
    $0.backgroundColor = .systemBackground
  }
  
  private let initialLabel = UILabel().then {
    $0.text = "영화와 팟캐스트를 검색해보세요"
    $0.font = .systemFont(ofSize: 18, weight: .medium)
    $0.textColor = .secondaryLabel
    $0.textAlignment = .center
  }
  
  var disposeBag = DisposeBag()
  var coordinator: AppCoordinator?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    [searchTermTitleLabel, searchBar, loadingIndicator,
     collectionView, emptyStateView, initialStateView]
      .forEach { view.addSubview($0) }
    
    emptyStateView.addSubview(emptyLabel)
    initialStateView.addSubview(initialLabel)
    
    setupConstraints()
  }
  
  // setupConstraints 메서드 수정
  private func setupConstraints() {
    searchTermTitleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(36)
    }
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(searchTermTitleLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(44)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(8)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    loadingIndicator.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    emptyStateView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    initialStateView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    initialLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  // MARK: - DataSource Configuration
  
  private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, SearchResultRow> {
    let movieCellRegistration = UICollectionView.CellRegistration<MovieCell, SearchResultRow> {
      cell, indexPath, item in
      if case .movie(let movie) = item {
        cell.configure(movie: movie)
      }
    }
    
    let podcastRowCellRegistration = UICollectionView.CellRegistration<PodcastRowCell, SearchResultRow> {
      cell, indexPath, item in
      if case .podcastPair(let first, let second) = item {
        cell.configure(first: first, second: second)
      }
    }
    
    return UICollectionViewDiffableDataSource<Int, SearchResultRow>(
      collectionView: collectionView
    ) { collectionView, indexPath, item in
      switch item {
      case .movie:
        return collectionView.dequeueConfiguredReusableCell(
          using: movieCellRegistration, for: indexPath, item: item
        )
      case .podcastPair:
        return collectionView.dequeueConfiguredReusableCell(
          using: podcastRowCellRegistration, for: indexPath, item: item
        )
      }
    }
  }
  
  // MARK: - Binding
  
  func bind(reactor: SearchViewReactor) {
    // Action
    searchBar.rx.searchButtonClicked
      .withLatestFrom(searchBar.rx.text.orEmpty)
      .filter { !$0.isEmpty }
      .map { SearchViewReactor.Action.search($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchBar.rx.cancelButtonClicked
      .map { SearchViewReactor.Action.goBackToHome }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchTermTitleLabel.rx.tapGesture
      .map { _ in SearchViewReactor.Action.goBackToHome }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // State
    reactor.state.map(\.isLoading)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(onNext: { [weak self] isLoading in
        self?.updateLoadingState(isLoading)
      })
      .disposed(by: disposeBag)
    
    reactor.state.map(\.searchTerm)
      .map { $0.isEmpty ? "Search" : $0 }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(to: searchTermTitleLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.searchRows)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(onNext: { [weak self] searchRows in
        self?.updateDataSource(with: searchRows)
      })
      .disposed(by: disposeBag)
    
    reactor.state.map(\.hasResults)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(onNext: { [weak self] hasResults in
        self?.updateViewState(hasResults: hasResults)
      })
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$errorAlert)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(onNext: { [weak self] error in
        self?.coordinator?.showErrorAlert(error)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - UI Update Methods
  
  private func updateLoadingState(_ isLoading: Bool) {
    if isLoading {
      loadingIndicator.startAnimating()
      collectionView.isHidden = true
      emptyStateView.isHidden = true
      initialStateView.isHidden = true
    } else {
      loadingIndicator.stopAnimating()
    }
  }
  
  private func updateViewState(hasResults: Bool) {
    let hasSearched = reactor?.currentState.searchResult != nil
    
    if hasSearched {
      // 검색을 했을 때
      collectionView.isHidden = !hasResults
      emptyStateView.isHidden = hasResults
      initialStateView.isHidden = true
    } else {
      // 아직 검색 안했을 때
      collectionView.isHidden = true
      emptyStateView.isHidden = true
      initialStateView.isHidden = false
    }
    
    searchTermTitleLabel.isHidden = false
  }
  
  private func updateDataSource(with searchRows: [SearchResultRow]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResultRow>()
    snapshot.appendSections([0])
    snapshot.appendItems(searchRows, toSection: 0)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - Layout Configuration

extension SearchViewController {
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { _, _ in
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(200)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(200)
      )
      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: groupSize,
        subitems: [item]
      )
      
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(
        top: 20, leading: 20, bottom: 20, trailing: 20
      )
      section.interGroupSpacing = 20
      
      return section
    }
  }
}
