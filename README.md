# iTunesStore

> iTunes Search API를 활용한 음악, 영화, 팟캐스트 검색 앱

## 📱 구현 완성 화면

### 홈 화면 (Music)
- 계절별 음악 추천 피드
- 다양한 레이아웃 구성 (Large/Small Cell)
- 검색바를 통한 검색 화면 진입

### 검색 화면 (Search)
- 영화, 팟캐스트 통합 검색
- 검색어 터치를 통한 홈 화면 복귀
- 다양한 셀 타입으로 검색 결과 표시

## 🏗️ 아키텍처

### Clean Architecture + ReactorKit

```
Presentation Layer
├── Views (UIViewController, UICollectionViewCell)
├── Reactor (ReactorKit)
└── Models (View용 데이터 모델)

Domain Layer
├── Entities (비즈니스 모델)
├── UseCases (비즈니스 로직)
└── Repository Interfaces

Data Layer
├── DTOs (API 응답 모델)
├── Repository Implementations
└── Network Service
```

### 아키텍처 선택 이유

**Clean Architecture 적용**
- 계층 간 의존성 역전을 통한 테스트 용이성 확보
- 비즈니스 로직과 UI 로직의 명확한 분리

**ReactorKit**
- 단방향 데이터 플로우로 상태 관리 단순화
- 반응형 프로그래밍 패러다임 구현

## 📚 기술 스택 및 라이브러리
- **RxSwift**
- **SnapKit**
- **Then**: UI 컴포넌트 초기화 코드 간소화
- **Dependencies**: 의존성 주입 구현
- **ReactorKit**: 단방향 데이터 플로우, 상태 관리 단순화
- **Kingfisher**: 이미지 로딩 및 캐싱 최적화

## 🎯 선택 키워드

### 1. 재사용성 (Reusability)

**재사용 가능한 UI 컴포넌트 설계**
- `LargeMusicCell`, `SmallMusicCell`: 음악 아이템 셀
- `MovieCell`, `PodcastCell`: 검색 결과 셀

**재사용 가능한 비즈니스 로직**
- `NetworkService`: 모든 API 호출에 재사용되는 네트워크 서비스
- Repository 패턴을 통한 데이터 접근 로직 재사용

### 2. 의존성 주입 (Dependency Injection)

**Dependencies 라이브러리를 통한 의존성 관리**
```swift
// Network Layer
var networkService: NetworkServiceInterface

// Repository Layer  
var musicRepository: MusicRepositoryInterface
var movieRepository: MovieRepositoryInterface
var podcastRepository: PodcastRepositoryInterface

// UseCase Layer
var seasonMusicUseCase: SeasonMusicUseCaseInterface
var searchUseCase: SearchUseCaseInterface
```

**의존성 주입의 장점**
- 각 계층 간 느슨한 결합 구현
- 테스트 시 Mock 객체 쉬운 주입
- 런타임이 아닌 컴파일 타임 의존성 해결

## 🔧 주요 구현 기능

### iTunes Search API 연동
- 계절별 음악 검색 (`봄`, `여름`, `가을`, `겨울`)
- 영화 및 팟캐스트 통합 검색
- 한국어 로케일 설정 (`lang: ko_KR`)

### UI/UX 
- **UICollectionView Compositional Layout** 활용
- 계절별 다른 레이아웃 적용 (Large: 1단, Small: 3단)
- Shadow 효과 및 Gradient Layer 적용
- 검색 화면의 실시간 검색어 표시

### 성능 최적화
- Kingfisher를 통한 이미지 캐싱
- RxSwift를 활용한 비동기 네트워크 처리
- DiffableDataSource 활용한 효율적인 UI 업데이트

## 🧪 테스트 구현

### Unit Test 커버리지
- **Repository Layer**: 네트워크 응답 처리 및 에러 핸들링
- **UseCase Layer**: 비즈니스 로직 검증
- **DTO Layer**: 데이터 변환 로직 검증

### Test Double 패턴 적용
- `NetworkServiceStub`: 네트워크 계층 테스트용
- `RepositoryStub`: UseCase 테스트용
- Swift Testing 프레임워크 활용

## 🎨 추가 구현 기능

### 요구사항 외 자율 구현 사항

**UI/UX 개선**
- 로딩 상태 및 빈 결과 상태 처리
- 검색 결과의 다양한 레이아웃 구성 (영화 1단, 팟캐스트 2단)

**성능 최적화**
- 이미지 크기별 최적화 로딩 (`100x100` vs `600x600`)
- Shadow Path 최적화로 렌더링 성능 향상


## 🔍 메모리 관리 분석

| DebugSwift | Instruments |
|------------|------------|
|<img width="200" src="https://github.com/user-attachments/assets/66172de7-b51b-4026-880f-52302ffd1203" />|<img width="600" src="https://github.com/user-attachments/assets/d273b934-2fdd-4665-9caf-7e0efcec8d35" />|
|Debug Swift 활용해 앱 실행 중 메모리 상태 실시간 확인|Leaks Instrument 실행으로 메모리 누수 여부 검증|

