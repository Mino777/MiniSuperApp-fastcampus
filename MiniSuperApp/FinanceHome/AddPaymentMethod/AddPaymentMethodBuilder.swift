//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/15.
//

import RIBs

protocol AddPaymentMethodDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
}

// MARK: - Builder

protocol AddPaymentMethodBuildable: Buildable {
  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting
}

final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {
  
  override init(dependency: AddPaymentMethodDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: AddPaymentMethodListener) -> AddPaymentMethodRouting {
    let component = AddPaymentMethodComponent(dependency: dependency)
    let viewController = AddPaymentMethodViewController()
    let interactor = AddPaymentMethodInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
  }
}