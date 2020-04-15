//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

@testable import SimpleMath
import XCTest

class EquationsFactoryImpTests: XCTestCase {
  
  func testMakeEquations_resultingMaxOperandDigitsIsTheSameCountAsInMaximumDigitNumberOfDigitsInEquationSettings() {
    let factory = EquationsFactoryImp()
    let equationSettings = EquationSettings.standard.set(\.maximumDigit, to: 133)
    let result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxOperandDigits,
      3,
      "Expected maxOperandDigits should be the digits count of the setting's maximumDigit, in this case 3 digits"
    )
  }
  
  func testMakeEquations_ifMultiplicationIsOneOfTheEquationTypes_resultingMaxAnswerDigitsIsCorrectlyCalculated() {
    let factory = EquationsFactoryImp()
    var equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 3)
      .set(\.equationTypes, to: [.addition, .subtraction, .multiplication, .division])
    var result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      1,
      "Expected maxAnswerDigits digits count in a resulting multiplication of the maximumDigit, 3 * 3 = 9, 9 has 1 digit"
    )
    
    equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 9)
      .set(\.equationTypes, to: [.addition, .subtraction, .multiplication, .division])
    result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      2,
      "Expected maxAnswerDigits digits count in a resulting multiplication of the maximumDigit, 9 * 9 = 81, 81 has 2 digits"
    )
    
    equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 20)
      .set(\.equationTypes, to: [.addition, .subtraction, .multiplication, .division])
    result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      3,
      "Expected maxAnswerDigits digits count in a resulting multiplication of the maximumDigit, 20 * 20 = 200, 200 has 3 digits"
    )
    
    equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 50)
      .set(\.equationTypes, to: [.addition, .subtraction, .multiplication, .division])
    result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      4,
      "Expected maxAnswerDigits digits count in a resulting multiplication of the maximumDigit, 50 * 50 = 2500, 2500 has 4 digits"
    )
  }
  
  func testMakeEquations_ifAdditionIsOneOfTheEquationTypesButNotMultiplication_resultingMaxAnswerDigitsIsCorrectlyCalculated() {
    let factory = EquationsFactoryImp()
    var equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 4)
      .set(\.equationTypes, to: [.addition, .subtraction, .division])
    var result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      1,
      "Expected maxAnswerDigits digits count in a resulting addition of the maximumDigit, 4 + 4 = 8, 8 has 1 digit"
    )
    
    equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 9)
      .set(\.equationTypes, to: [.addition, .subtraction, .division])
    result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      2,
      "Expected maxAnswerDigits digits count in a resulting addition of the maximumDigit, 9 + 9 = 18, 18 has 2 digits"
    )
    
    equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 50)
      .set(\.equationTypes, to: [.addition, .subtraction, .division])
    result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      3,
      "Expected maxAnswerDigits digits count in a resulting addition of the maximumDigit, 50 + 50 = 100, 100 has 3 digits"
    )
  }
  
  func testMakeEquations_ifAdditionOrMultiplicationIsNotOneOfTheEquationTypes_resultingMaxAnswerDigitsIsCorrectlyCalculated() {
    let factory = EquationsFactoryImp()
    var equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 9)
      .set(\.equationTypes, to: [.subtraction, .division])
    var result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      1,
      "Expected maxAnswerDigits digits to be the same as the maximumDigit number of digits"
    )
    
    equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 10)
      .set(\.equationTypes, to: [.subtraction, .division])
    result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      2,
      "Expected maxAnswerDigits digits to be the same as the maximumDigit number of digits"
    )
    
    equationSettings = EquationSettings.standard
      .set(\.maximumDigit, to: 99)
      .set(\.equationTypes, to: [.subtraction, .division])
    result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.maxAnswerDigits,
      2,
      "Expected maxAnswerDigits digits to be the same as the maximumDigit number of digits"
    )
  }

  func testMakeEquations_producesNumberOfEquationsDefinedInEquationSettings() {
    let factory = EquationsFactoryImp()
    let equationSettings = EquationSettings.standard.set(\.equationsCount, to: 25)
    let result = factory.makeEquations(usingSettings: equationSettings)
    XCTAssertEqual(
      result.equations.count,
      25,
      "Expected nuumber of created equations should be the same count set in the equationSettings"
    )
  }
  
  func testMakeEquations_producesEveryEquationTypeSpecifiedInTheEquationSettings() {
    let factory = EquationsFactoryImp()
    // all permutations
    let subsets: [Set<EquationType>] = [
      [.addition], [.subtraction], [.multiplication], [.division], [.addition, .subtraction], [.addition, .multiplication],
      [.addition, .division], [.addition, .subtraction, .multiplication], [.addition, .subtraction, .division],
      [.addition, .multiplication, .division], [.addition, .subtraction, .multiplication, .division],
      [.subtraction, .multiplication], [.subtraction, .division], [.subtraction, .multiplication, .division],
      [.multiplication, .division]
    ]

    for set in subsets {
      let equationSettings = EquationSettings.standard.set(\.equationTypes, to: set)
      let result = factory.makeEquations(usingSettings: equationSettings)
      XCTAssertTrue(
        result.equations.allSatisfy { set.contains($0.type) },
        "Expected all equations to be one of [\(set.map(\.rawValue).joined(separator: ", "))]"
      )
    }
  }
  
  func testMakeEquations_triesToProduceEqualAmountOfEquationsOfCertainType() {
    let factory = EquationsFactoryImp()
    let equationSettings = EquationSettings.standard
      .set(\.equationsCount, to: 12)
      .set(\.equationTypes, to: [.addition, .subtraction, .multiplication, .division])
    let result = factory.makeEquations(usingSettings: equationSettings)
    let types = Dictionary(grouping: result.equations, by: \.type)
    // since there are 12 total equations, and 4 types, expected count is 12/4 = 3 equations of each type
    XCTAssertEqual(types[.addition]?.count, 3, "expected 3 addition equations")
    XCTAssertEqual(types[.subtraction]?.count, 3, "expected 3 subtraction equations")
    XCTAssertEqual(types[.multiplication]?.count, 3, "expected 3 multiplication equations")
    XCTAssertEqual(types[.division]?.count, 3, "expected 3 division equations")
  }
  
  func testMakeEquations_addition_RandomizedOperandsFallWithinExpectedValues() {
    let factory = EquationsFactoryImp()
    // larger sample of 50 equations to get more varriation
    let equationSettings = EquationSettings.standard
      .set(\.equationsCount, to: 50)
      .set(\.minimumDigit, to: 1)
      .set(\.maximumDigit, to: 5)
      .set(\.equationTypes, to: [.addition])
    let result = factory.makeEquations(usingSettings: equationSettings)
    let expectedRange = (equationSettings.minimumDigit...equationSettings.maximumDigit)
    XCTAssertTrue(
      result.equations.allSatisfy{ expectedRange.contains($0.left) || expectedRange.contains($0.right) },
      "All left and right operands should be within range of minimum and maximum digit"
    )
  }
  
  func testMakeEquations_subtraction_RandomizedOperandsFallWithinExpectedValues() {
    let factory = EquationsFactoryImp()
    // larger sample of 50 equations to get more varriation
    let equationSettings = EquationSettings.standard
      .set(\.equationsCount, to: 50)
      .set(\.minimumDigit, to: 1)
      .set(\.maximumDigit, to: 5)
      .set(\.equationTypes, to: [.subtraction])
    let result = factory.makeEquations(usingSettings: equationSettings)
    let expectedLeftRange = (equationSettings.minimumDigit...equationSettings.maximumDigit)
    XCTAssertTrue(
      result.equations.allSatisfy{ expectedLeftRange.contains($0.left) },
      "All left operands should be within range of minimum and maximum digit"
    )
    XCTAssertTrue(
      result.equations.allSatisfy{ (equationSettings.minimumDigit...$0.left).contains($0.right) },
      "All right operands should be within range of minimum digit and the right operand"
    )
  }
  
  func testMakeEquations_multiplication_RandomizedOperandsFallWithinExpectedValues() {
    let factory = EquationsFactoryImp()
    // larger sample of 50 equations to get more varriation
    let equationSettings = EquationSettings.standard
      .set(\.equationsCount, to: 50)
      .set(\.minimumDigit, to: 1)
      .set(\.maximumDigit, to: 5)
      .set(\.equationTypes, to: [.multiplication])
    let result = factory.makeEquations(usingSettings: equationSettings)
    let expectedRange = (equationSettings.minimumDigit...equationSettings.maximumDigit)
    XCTAssertTrue(
      result.equations.allSatisfy{ expectedRange.contains($0.left) || expectedRange.contains($0.right) },
      "All left and right operands should be within range of minimum and maximum digit"
    )
  }
  
  func testMakeEquations_division_RandomizedOperandsFallWithinExpectedValues() {
    let factory = EquationsFactoryImp()
    // larger sample of 100 equations to get more varriation
    let equationSettings = EquationSettings.standard
      .set(\.equationsCount, to: 50)
      .set(\.minimumDigit, to: 0)
      .set(\.maximumDigit, to: 9)
      .set(\.equationTypes, to: [.division])
    let result = factory.makeEquations(usingSettings: equationSettings)
    let expectedLeftRange = (equationSettings.minimumDigit...equationSettings.maximumDigit)
    XCTAssertTrue(
      result.equations.allSatisfy{ expectedLeftRange.contains($0.left) },
      "All left operands should be within range of minimum and maximum digit"
    )
    XCTAssertTrue(
      result.equations.allSatisfy{
        $0.left == 0
          ? (equationSettings.minimumDigit + 1...equationSettings.maximumDigit).contains($0.right)
          : (equationSettings.minimumDigit + 1...$0.left).contains($0.right)
      },
      """
        If left operand is 0, all right operands should be within range of minimum and maximum digit (but not 0)
        Otherwise all right operands must be within range of minimum digit and left operand (but not 0)
      """
    )
    XCTAssertTrue(result.equations.allSatisfy{ $0.left % $0.right == 0 }, "All division must be without remainder")
    XCTAssertTrue(
      result.equations.filter { $0.left.isPrime }.count < equationSettings.equationsCount / 2,
      "expected less exuations where left (dividend) is a prime number"
    )
  }
  
}

private extension EquationSettings {
  static let standard = EquationSettings(
    minimumDigit: 0,
    maximumDigit: 9,
    equationsCount: 10,
    equationTypes: [.addition, .subtraction]
  )
}
