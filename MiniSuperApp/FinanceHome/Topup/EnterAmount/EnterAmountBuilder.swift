//
//  EnterAmountBuilder.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/16.
//

import RIBs
import RxRelay

protocol EnterAmountDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  var selectedPaymentMethod: BehaviorRelay<PaymentMethodModel> { get }
  var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountInteractorDependency {
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
  var selectedPaymentMethod: BehaviorRelay<PaymentMethodModel> { dependency.selectedPaymentMethod }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
  func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {
  
  override init(dependency: EnterAmountDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
    let component = EnterAmountComponent(dependency: dependency)
    let viewController = EnterAmountViewController()
    let interactor = EnterAmountInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return EnterAmountRouter(interactor: interactor, viewController: viewController)
  }
}
