//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

final class EquationsFactoryMock: EquationsFactory {
  private let results : GeneratedResult
  var equationSettings: EquationSettings?
  
  init(_ create: () -> GeneratedResult) {
    results = create()
  }
  
  func makeEquations(usingSettings: EquationSettings) -> GeneratedResult {
    equationSettings = usingSettings
    return results
  }
  
  
}
