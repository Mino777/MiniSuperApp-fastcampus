//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by 조민호 on 2022/11/14.
//

import Foundation

struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
