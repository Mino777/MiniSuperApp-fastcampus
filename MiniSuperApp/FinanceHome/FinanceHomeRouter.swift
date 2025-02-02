import RIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?
  
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let topupBuildable: TopupBuildable
  private var topupRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    topupBuildable: TopupBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.topupBuildable = topupBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachSuperPayDashboard() {
    // 같은 자식 리블렛을 붙이지 않기 위한 방어 코드
    if superPayRouting != nil {
      return
    }
    
    let router = superPayDashboardBuildable.build(withListener: interactor)
    
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.superPayRouting = router
    attachChild(router)
  }
  
  func attachCardOnFileDashboard() {
    if cardOnFileRouting != nil {
      return
    }
    
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.cardOnFileRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil {
      return
    }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: .close)
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)
    
    self.addPaymentMethodRouting = router
    attachChild(router)
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }
    
    viewControllable.dismiss(completion: nil)
    
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  func attachTopup() {
    if topupRouting != nil {
      return
    }
    
    let router = topupBuildable.build(withListener: interactor)
    
    self.topupRouting = router
    attachChild(router)
  }
  
  func detatchTopup() {
    guard let router = topupRouting else { return }

    detachChild(router)
    topupRouting = nil
  }
}
