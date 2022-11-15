import RIBs

protocol AppRootInteractable: Interactable,
                              AppHomeListener,
                              FinanceHomeListener,
                              ProfileHomeListener {
  var router: AppRootRouting? { get set }
  var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
  func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
  
  private let appHome: AppHomeBuildable
  private let financeHome: FinanceHomeBuildable
  private let profileHome: ProfileHomeBuildable
  
  private var appHomeRouting: ViewableRouting?
  private var financeHomeRouting: ViewableRouting?
  private var profileHomeRouting: ViewableRouting?
  
  init(
    interactor: AppRootInteractable,
    viewController: AppRootViewControllable,
    appHome: AppHomeBuildable,
    financeHome: FinanceHomeBuildable,
    profileHome: ProfileHomeBuildable
  ) {
    self.appHome = appHome
    self.financeHome = financeHome
    self.profileHome = profileHome
    
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachTabs() {
    let appHomeRouting = appHome.build(withListener: interactor)
    let financeHomeRouting = financeHome.build(withListener: interactor)
    let profileHomeRouting = profileHome.build(withListener: interactor)
    
    // attachChild: ribs 내장 메서드
    // 립스 트리를 만들어서 각 리블렛들의 레퍼런스를 유지하고, interactor의 라이프 사이클 관련 메서드를 호출하는 작업
    attachChild(appHomeRouting)
    attachChild(financeHomeRouting)
    attachChild(profileHomeRouting)
    
    let viewControllers = [
      // 리블렛의 뷰는 router의 viewControllable 프로퍼티를 통해 가져올 수 있음
      // viewControllable: UIViewController를 한번 래핑해준 인터페이스
      // 왜 래핑함?
      // UIKit을 숨기고 싶어서. 그래서 보통 router에서 import uikit이 없음
      // UIKit을 import하지 않았을 때 장점이 몇개있는데 그건 다음에~
      // -> uikit을 import하는 경우에는 재사용이 제한 된다 정도 예상쓰
      NavigationControllerable(root: appHomeRouting.viewControllable),
      // NavigationControllerable -> UINavigationController를 숨기기 위한 래핑 객체
      NavigationControllerable(root: financeHomeRouting.viewControllable),
      profileHomeRouting.viewControllable
    ]
    
    // 자식 리블렛을 붙이고 싶으면, 자식 리블렛의 빌더를 만들고 빌드 메서드를 통해서 라우터를 받아와서
    // attachChild를 하고 UIViewController를 띄운다
    
    viewController.setViewControllers(viewControllers)
  }
}
