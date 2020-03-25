//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation

struct EquationGenerator {
  let count: Int
  let upperLimit: Int
  
  func generate() -> [Equation] {
    (0..<count).map { $0 % 2 == 0 ? makeValidAddition() : makeValidSubtraction() }
  }
  
  private func makeValidAddition() -> Equation {
    let left = Int.random(in: 0...upperLimit)
    let right = Int.random(in: 0...upperLimit)
    return Equation(left: left, right: right, operator: .add)
  }
  
  private func makeValidSubtraction() -> Equation {
    let right = Int.random(in: 0...upperLimit)
    let left = Int.random(in: right...upperLimit)
    return Equation(left: left, right: right, operator: .subtract)
  }
}
