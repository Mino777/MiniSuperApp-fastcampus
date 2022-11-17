//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/16.
//

import RIBs
import RxSwift

protocol CardOnFileRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
  // TODO: Declare methods the interactor can invoke the presenter to present data.
  var listener: CardOnFilePresentableListener? { get set }
  
  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func cardOnFileDidTapClose()
  func cardOnFileDidTapAddCard()
  func cardOnFileDidSelect(at index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {
  
  weak var router: CardOnFileRouting?
  weak var listener: CardOnFileListener?
  
  private let paymentMethods: [PaymentMethodModel]
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: CardOnFilePresentable,
    paymentMethods: [PaymentMethodModel]
  ) {
    self.paymentMethods = paymentMethods
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    presenter.update(with: paymentMethods.map(PaymentMethodViewModel.init))
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func didTapClose() {
    listener?.cardOnFileDidTapClose()
  }
  
  func didSelectItem(at index: Int) {
    if index >= paymentMethods.count {
      listener?.cardOnFileDidTapAddCard()
    } else {
      listener?.cardOnFileDidSelect(at: index)
    }
  }
}
