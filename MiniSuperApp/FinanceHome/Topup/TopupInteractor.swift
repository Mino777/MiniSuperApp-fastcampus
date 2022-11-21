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
  func attachAddPaymentMethod(closeButtonType: DismissButtonType)
  func detachAddPaymentMethod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethodModel])
  func detachCardOnFile()
  func popToRoot()
}

protocol TopupListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func topupDidClose()
  func topupDidFinish()
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
  
  private var isEnterAmountRoot: Bool = false
  
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
      isEnterAmountRoot = true
      dependency.paymentMethodStream.accept(card)
      router?.attachEnterAmount()
    } else {
      isEnterAmountRoot = false
      router?.attachAddPaymentMethod(closeButtonType: .close)
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
    if isEnterAmountRoot == false {
      listener?.topupDidClose()
    }
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethodModel) {
    dependency.paymentMethodStream.accept(paymentMethod)
    
    if isEnterAmountRoot {
      router?.popToRoot()
    } else {
      isEnterAmountRoot = true
      router?.attachEnterAmount()
    }
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymentMethods)
  }
  
  func enterAmountDidFinishTopup() {
    listener?.topupDidFinish()
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    router?.attachAddPaymentMethod(closeButtonType: .back)
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMethods[safe: index] {
      dependency.paymentMethodStream.accept(selected)
    }
    router?.detachCardOnFile()
  }
}
