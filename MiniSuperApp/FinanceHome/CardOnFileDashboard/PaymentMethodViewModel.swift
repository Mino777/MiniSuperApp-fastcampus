//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/15.
//

import UIKit

struct PaymentMethodViewModel {
  let name: String
  let digits: String
  let color: UIColor
  
  init(_ paymentMethod: PaymentMethodModel) {
    name = paymentMethod.name
    digits = "**** \(paymentMethod.digits)"
    color = UIColor(hex: paymentMethod.color) ?? .systemGray
  }
}

