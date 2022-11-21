//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/15.
//

import RIBs
import RxRelay

protocol TopupDependency: Dependency {
  // TODO: Make sure to convert the variable into lower-camelcase.
  // TODO: Declare the set of dependencies required by this RIB, but won't be
  // created by this RIB.
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
  // TODO: Make sure to convert the variable into lower-camelcase.
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var selectedPaymentMethod: BehaviorRelay<PaymentMethodModel> { paymentMethodStream }
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  
  fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }
  
  let paymentMethodStream: BehaviorRelay<PaymentMethodModel>
  
  init(
    dependency: TopupDependency,
    paymentMethodStream: BehaviorRelay<PaymentMethodModel>
  ) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
  }
  
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TopupListener) -> TopupRouting {
    let paymentMethodStream = BehaviorRelay(value: PaymentMethodModel(id: "", name: "", digits: "", color: "", isPrimary: false))
    
    let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
    
    return TopupRouter(
      interactor: interactor,
      viewController: component.topupBaseViewController,
      addPaymentMethodBuildable: addPaymentMethodBuilder,
      enterAmountBuildable: enterAmountBuilder,
      cardOnFileBuildable: cardOnFileBuilder
    )
  }
}
