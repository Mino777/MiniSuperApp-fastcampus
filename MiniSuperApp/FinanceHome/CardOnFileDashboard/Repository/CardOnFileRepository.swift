//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/15.
//

import Foundation
import RxSwift
import RxRelay

protocol CardOnFileRepository {
  var cardOnFile: BehaviorRelay<[PaymentMethodModel]> { get }
  func addCard(info: AddPaymentMethodInfoModel) -> Observable<PaymentMethodModel>
}

final class CardOnFileRepositoryImpl: CardOnFileRepository {

  var cardOnFile: RxRelay.BehaviorRelay<[PaymentMethodModel]> { paymentMethodRelay }
  
  private let paymentMethodRelay = BehaviorRelay<[PaymentMethodModel]>(
    value: [
      PaymentMethodModel(id: "00", name: "New 카드", digits: "", color: "", isPrimary: false)
    ]
  )
  
  func addCard(info: AddPaymentMethodInfoModel) -> Observable<PaymentMethodModel> {
    let paymentMethod = PaymentMethodModel(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
    
    var new = paymentMethodRelay.value
    new.append(paymentMethod)
    paymentMethodRelay.accept(new)
    
    return .just(paymentMethod)
  }
}
