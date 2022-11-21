//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/17.
//

import Foundation
import RxSwift
import RxRelay

protocol SuperPayRepository {
  var balance: BehaviorRelay<Double> { get }
  func topup(amount: Double, paymentMethodID: String) -> Observable<Void>
}

final class SuperPayRepositoryImpl: SuperPayRepository {
  var balance: BehaviorRelay<Double> { balanceRelay }
  private let balanceRelay = BehaviorRelay<Double>(value: 0)
  private let disposeBag = DisposeBag()
  private let bgQueue = DispatchQueue(label: "topup.repository.queue")
  
  func topup(amount: Double, paymentMethodID: String) -> Observable<Void> {
    return Observable.create({ [weak self] promise in
      self?.bgQueue.async {
        Thread.sleep(forTimeInterval: 2)
        promise.onNext(())
        let newBalance = (self?.balanceRelay.value).map { $0 + amount }
        newBalance.map { self?.balanceRelay.accept($0) }
      }
      
      return Disposables.create()
    })
  }
}
