//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

protocol EquationsFactory {
  func makeEquations(usingSettings: EquationSettings) -> GeneratedResult
}
