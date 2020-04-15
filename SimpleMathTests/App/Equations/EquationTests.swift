//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

@testable import SimpleMath
import XCTest

class EquationTests: XCTestCase {
    
  func testInit_hasExpectedDefaultValues() {
    let equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    XCTAssertEqual(equation.currentAnswerText, "", "by default currentAnswerText is empty string")
    XCTAssertFalse(equation.finishedAnswering, "by default finishedAnswering is false")
    XCTAssertFalse(equation.hasValidAnswer, "by default hasValidAnswer is false")
    XCTAssertFalse(equation.correctlyAnswered, "by default correctlyAnswered is false")
  }
  
  func testQuestion_isCorrectlyFormatted() {
    let equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    XCTAssertEqual(equation.question, "4 mod 2 = ", "expected format is `operand operator operant = `")
  }
  
  func testCorrectAnswer_executesOperatorUsingOperandsCorrectlyToProduceAnswer() {
    let equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    XCTAssertEqual(equation.correctAnswer, 0, "Expected 4 % 2 == 0")
  }
  
  func testAppendDigit_updatesCurrentAnswerTextAndHasValidAnswerAndCorrectlyAnswered() {
    var equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    equation.append(digit: 0)
    XCTAssertEqual(equation.currentAnswerText, "0", "currentAnswerText should be string representaiton of `0`")
    XCTAssertTrue(equation.hasValidAnswer, "If any digit has been provided than it is a `validAnswer`")
    XCTAssertTrue(equation.correctlyAnswered, "if the provided digits evaluate to correct answer than it should be `true`")
  }
  
  func testAppendDigit_correctlyAppendsTheLastDigitAndCanNotPassTheAnswerDigitLimit() {
    var equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    equation.append(digit: 1)
    equation.append(digit: 1)
    equation.append(digit: 1) // nothing should happen
    XCTAssertEqual(equation.currentAnswerText, "11", "expected only 2 `1s` to be appended giving `11`, third one surpassed maximum")
  }
  
  func testErase_correctlyRemovesDigitsAndInvalidatesHasValidAnswerAndCorrectlyAnswered() {
    var equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    equation.append(digit: 0) // this makes the equation have a valid and correct answer
    equation.erase()
    XCTAssertEqual(equation.currentAnswerText, "", "after erasing the last digit, currentAnswerText should be empty string")
    XCTAssertFalse(equation.hasValidAnswer, "after erasing the last digit, hasValidAnswer should be false")
    XCTAssertFalse(equation.correctlyAnswered, "after erasing last digit there is no answer to compare against correct one, so false")
  }
  
  func testEvaluate_ifAnyAnswerWasProvided_setsFinishedAnsweringTrue() {
    var equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    equation.append(digit: 0)
    equation.evaluate()
    XCTAssertTrue(equation.finishedAnswering, "when evaluate is called with valid answer, finishedAnswering is set to true")
  }
  
  func testEvaluate_ifNoAnswerWasProvided_DoesNothing() {
    var equation = Equation(left: 4, right: 2, operator: .testOperator, answerDigitLimit: 2)
    equation.evaluate()
    XCTAssertFalse(equation.finishedAnswering, "when evaluate is called with no valid answer, finishedAnswering is still false")
  }
  
}

extension Operator {
  static let testOperator = Operator(equationType: .addition, symbol: "mod", function: %)
}
