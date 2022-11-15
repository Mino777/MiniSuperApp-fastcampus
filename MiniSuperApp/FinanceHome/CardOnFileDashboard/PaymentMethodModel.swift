//
//  PaymentMethodModel.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/15.
//

import Foundation

struct PaymentMethodModel: Decodable {
  let id: String
  let name: String
  let digits: String
  let color: String
  let isPrimary: Bool
}
