//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/15.
//

import RIBs
import RxSwift
import RxRelay

protocol TopupRouting: Routing {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
  func cleanupViews()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethodModel])
  func detachCardOnFile()
}

protocol TopupListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: BehaviorRelay<PaymentMethodModel> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
      
  weak var router: TopupRouting?
  weak var listener: TopupListener?
  
  private let dependency: TopupInteractorDependency
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private var paymentMethods: [PaymentMethodModel] {
    dependency.cardOnFileRepository.cardOnFile.value
  }
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    dependency: TopupInteractorDependency
  ) {
    self.dependency = dependency
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init()
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    
    if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
      dependency.paymentMethodStream.accept(card)
      router?.attachEnterAmount()
    } else {
      router?.attachAddPaymentMethod()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    // viewFull 리블렛과는 달리 viewLess 리블렛의 경우 부모가 자식 리블렛을 dismiss 해줄 책임이 없음
    // 따라서 viewLess 리블렛의 경우 자신이 직접 dismiss처리를 해줘야함 -> cleanUpViews 메서드가 있는 이유
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethodModel) {
    router?.detachAddPaymentMethod()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymentMethods)
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMethods[safe: index] {
      dependency.paymentMethodStream.accept(selected)
    }
    router?.detachCardOnFile()
  }
}
