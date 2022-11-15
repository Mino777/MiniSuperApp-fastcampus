import RIBs

public protocol AppHomeDependency: Dependency {
}

final class AppHomeComponent: Component<AppHomeDependency>, TransportHomeDependency {
}

// MARK: - Builder
// builder는 리블렛 객체들을 생성하는 역할
// AppHomeBuilder는 App Home 리블렛을 만든다.

public protocol AppHomeBuildable: Buildable {
  func build(withListener listener: AppHomeListener) -> ViewableRouting
}

public final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {
  
  public override init(dependency: AppHomeDependency) {
    super.init(dependency: dependency)
  }
  
  // build 메서드가 중요
  // 리블렛에 필요한 객체들을 생성해주는 역할
  // 라우터를 리턴해주는 역할
  // Listenr: 부모 리블렛에게 이벤트를 전달할 때 사용. 익숙하고 단순한 delegate 패턴. 이름만 listenr
  public func build(withListener listener: AppHomeListener) -> ViewableRouting {
    // component: 로직을 수행하는데 필요한 객체들을 담고있기위한 바구니
    let component = AppHomeComponent(dependency: dependency)
    let viewController = AppHomeViewController()
    // interactor: 비즈니스 로직
    let interactor = AppHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let transportHomeBuilder = TransportHomeBuilder(dependency: component)
    
    // 립스는 트리구조
    // 리블렛은 여러개의 자식 리블렛을 가질 수 있고 하나의 부모 리블렛을 가짐
    // 자식 리블렛을 떼었다 붙었다 하는게 라우터의 역할
    // return되는 라우터의 경우 부모 리블렛이 사용
    // 부모 리블렛은 해당 라우터를 가지고 두가지의 작업을 해줌
    // 
    return AppHomeRouter(
      interactor: interactor,
      viewController: viewController,
      transportHomeBuildable: transportHomeBuilder
    )
  }
}
