//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/11.
//

import Foundation

import RIBs
import RxSwift
import RxRelay

protocol SuperPayDashboardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
  // TODO: Declare methods the interactor can invoke the presenter to present data.
  var listener: SuperPayDashboardPresentableListener? { get set }
  
  func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol SuperPayDashboardInteractorDependency {
  var balance: BehaviorRelay<Double> { get }
  var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {
  
  weak var router: SuperPayDashboardRouting?
  weak var listener: SuperPayDashboardListener?
  
  private let dependency: SuperPayDashboardInteractorDependency
  private let disposeBag = DisposeBag()
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: SuperPayDashboardPresentable,
    dependency: SuperPayDashboardInteractorDependency
  ) {
    self.dependency = dependency
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    
    dependency.balance
      .subscribe (onNext: { [weak self] balance in
        self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map({
          self?.presenter.updateBalance($0)
        })
    }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
