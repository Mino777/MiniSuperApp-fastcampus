//
//  CardOnFileDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/14.
//

import RIBs

protocol CardOnFileDashboardDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardComponent: Component<CardOnFileDashboardDependency>, CardOnFileDashboardInteractorDependency {
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
}

// MARK: - Builder

protocol CardOnFileDashboardBuildable: Buildable {
  func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting
}

final class CardOnFileDashboardBuilder: Builder<CardOnFileDashboardDependency>, CardOnFileDashboardBuildable {
  
  override init(dependency: CardOnFileDashboardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting {
    let component = CardOnFileDashboardComponent(dependency: dependency)
    let viewController = CardOnFileDashboardViewController()
    let interactor = CardOnFileDashboardInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return CardOnFileDashboardRouter(interactor: interactor, viewController: viewController)
  }
}
