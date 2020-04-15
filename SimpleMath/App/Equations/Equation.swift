//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct Equation: Equatable {  
  private var answer: Int?
  private let op: Operator
  private let answerDigitLimit: Int
  var type: EquationType { op.equationType }
  let left: Int
  let right: Int
  var question: String { "\(left) \(op.symbol) \(right) = " }
  var correctAnswer: Int { op(left,right) }
  var currentAnswerText: String { answer?.description ?? "" }
  var finishedAnswering = false
  var correctlyAnswered: Bool { answer == correctAnswer }
  var hasValidAnswer: Bool { answer != nil }
  
  init(left: Int, right: Int, operator: Operator, answerDigitLimit: Int) {
    op = `operator`
    self.left = left
    self.right = right
    self.answerDigitLimit = answerDigitLimit
  }
  
  mutating func append(digit: Int) {
    if let current = answer {
      guard current < 10.toThePower(of: answerDigitLimit - 1) else { return }
      answer = current * 10 + digit
    } else {
      answer = digit
    }
  }
  
  mutating func erase() {
    guard let current = answer else { return }
    answer = current > 9 ? current / 10 : nil
  }
  
  mutating func evaluate() {
    if answer != nil {
      finishedAnswering = true
    }
  }
}

extension Array where Element == Equation {
  var answeredAllCorrectly: Bool {
    self.allSatisfy{ $0.correctlyAnswered && $0.finishedAnswering }
  }
}

private extension Int {
  func toThePower(of power: Int) -> Int {
    var answer = 1
    for _ in 0..<power { answer *= self }
    return answer
  }
}
