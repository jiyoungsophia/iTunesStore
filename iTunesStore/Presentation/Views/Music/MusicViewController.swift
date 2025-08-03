//
//  MusicViewController.swift
//  iTunesStore
//
//  Created by Milou on 8/1/25.
//

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class MusicViewController: UIViewController, View {
  
  // MARK: - UI Components
  
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
  
  private let searchBar = UISearchBar().then {
    $0.backgroundColor = .systemBackground
    $0.placeholder = "영화, 팟캐스트"
    $0.searchBarStyle = .minimal
  }
  
  var disposeBag = DisposeBag()
  var coordinator: AppCoordinator?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    title = "Music"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .automatic
    
    view.backgroundColor = .systemBackground
    
    [searchBar, collectionView, loadingIndicator]
      .forEach { view.addSubview($0) }
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
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
  }
  
  private func makeDataSource() -> UICollectionViewDiffableDataSource<MusicSection, MusicItem> {
    let largeCellRegistration = UICollectionView.CellRegistration<LargeMusicCell, MusicItem> {
      cell, indexPath, musicItem in
      cell.configure(music: musicItem.music)
    }
    
    let smallCellRegistration = UICollectionView.CellRegistration<SmallMusicCell, MusicItem> {
      cell, indexPath, musicItem in
      cell.configure(music: musicItem.music)
    }
    
    let headerRegistration = UICollectionView.SupplementaryRegistration<MusicSectionHeaderView>(
      elementKind: UICollectionView.elementKindSectionHeader
    ) { headerView, _, indexPath in
      let section = MusicSection(rawValue: indexPath.section)!
      headerView.configure(section: section)
    }
    
    let dataSource = UICollectionViewDiffableDataSource<MusicSection, MusicItem>(
      collectionView: collectionView
    ) { collectionView, indexPath, musicItem in
      
      let section = MusicSection(rawValue: indexPath.section)!
      switch section.layoutType {
      case .large:
        return collectionView.dequeueConfiguredReusableCell(
          using: largeCellRegistration, for: indexPath, item: musicItem
        )
      case .small:
        return collectionView.dequeueConfiguredReusableCell(
          using: smallCellRegistration, for: indexPath, item: musicItem
        )
      }
    }
    
    dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
      return collectionView.dequeueConfiguredReusableSupplementary(
        using: headerRegistration, for: indexPath
      )
    }
    
    return dataSource
  }
  
  // MARK: - Binding
  
  func bind(reactor: MusicViewReactor) {
    // Action
    Observable.just(())
      .map { MusicViewReactor.Action.loadSeasonMusic }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchBar.rx.textDidBeginEditing
      .bind(onNext: { [weak self] in
        self?.searchBar.resignFirstResponder()
        self?.coordinator?.showSearchScreen()
      })
      .disposed(by: disposeBag)
    
    // State
    reactor.state.map(\.isLoading)
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(onNext: { [weak self] isLoading in
        self?.updateLoadingState(isLoading)
      })
      .disposed(by: disposeBag)
    
    reactor.state.map(\.seasonMusic)
      .distinctUntilChanged { lhs, rhs in
        lhs.keys == rhs.keys
      }
      .observe(on: MainScheduler.instance)
      .bind(onNext: { [weak self] seasonMusic in
        self?.updateDataSource(with: seasonMusic)
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
    } else {
      loadingIndicator.stopAnimating()
      collectionView.isHidden = false
    }
  }
  
  private func updateDataSource(with seasonMusic: [SeasonType: [Music]]) {
    var snapshot = NSDiffableDataSourceSnapshot<MusicSection, MusicItem>()
    snapshot.appendSections(MusicSection.allCases)
    
    for section in MusicSection.allCases {
      let musics = seasonMusic[section.seasonType] ?? []
      let limitedMusics = Array(musics.prefix(section.maxItemCount))
      let musicItems = limitedMusics.map { MusicItem(music: $0, section: section) }
      
      snapshot.appendItems(musicItems, toSection: section)
    }
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - Layout Configuration

extension MusicViewController {
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, _ in
      let section = MusicSection(rawValue: sectionIndex)!
      
      switch section.layoutType {
      case .large:
        return self.createLargeItemSection()
      case .small:
        return self.createSmallItemSection()
      }
    }
  }
  
  private func createLargeItemSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(300)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 0, leading: 5, bottom: 0, trailing: 5
    )
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.93),
      heightDimension: .absolute(300)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 0, leading: 16, bottom: 24, trailing: 16
    )
    section.boundarySupplementaryItems = [createSectionHeader()]
    
    return section
  }
  
  private func createSmallItemSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(60)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 2, leading: 0, bottom: 2, trailing: 0
    )
    
    let subGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.9),
      heightDimension: .absolute(180)
    )
    let subGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: subGroupSize,
      subitems: [item, item, item]
    )
    
    let section = NSCollectionLayoutSection(group: subGroup)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 0, leading: 16, bottom: 24, trailing: 16
    )
    section.boundarySupplementaryItems = [createSectionHeader()]
    
    return section
  }
  
  private func createSectionHeader()
  -> NSCollectionLayoutBoundarySupplementaryItem {
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(80)
    )
    
    return NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
  }
}
