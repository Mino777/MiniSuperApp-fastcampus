//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/16.
//

import RIBs
import RxSwift
import RxRelay

protocol EnterAmountRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
  // TODO: Declare methods the interactor can invoke the presenter to present data.
  var listener: EnterAmountPresentableListener? { get set }
  
  func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
}

protocol EnterAmountListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func enterAmountDidTapClose()
  func enterAmountDidTapPaymentMethod()
}

protocol EnterAmountInteractorDependency {
  var selectedPaymentMethod: BehaviorRelay<PaymentMethodModel> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
  
  weak var router: EnterAmountRouting?
  weak var listener: EnterAmountListener?
  
  private let dependency: EnterAmountInteractorDependency
  private let disposeBag = DisposeBag()
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: EnterAmountPresentable,
    dependency: EnterAmountInteractorDependency
  ) {
    self.dependency = dependency
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    dependency.selectedPaymentMethod
      .subscribe (onNext: { [weak self] paymentMethod in
        self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func didTapClose() {
    listener?.enterAmountDidTapClose()
  }
  
  func didTapPaymentMethod() {
    listener?.enterAmountDidTapPaymentMethod()
  }
  
  func didTapTopup(with amount: Double) {
    
  }
}
