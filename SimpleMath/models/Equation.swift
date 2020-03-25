//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct Equation {
  enum Answer {
    case noAnswer
    case answer(Int)
    
    var text: String {
      switch self {
      case .noAnswer: return " "
      case let .answer(answer): return answer.description
      }
    }
  }
  
  private let left: Int
  private let right: Int
  private var answer: Answer = .noAnswer
  private let op: Operator
  var finishedAnswering = false
  var question: String { "\(left) \(op.symbol) \(right) =" }
  var correctAnswer: Int { op.function(left,right) }
  var currentAnswerText: String { answer.text }
  var correctlyAnswered: Bool {
    guard case let .answer(current) = answer else { return false }
    return current == correctAnswer
  }
  var hasValidAnswer: Bool {
    guard case .answer = answer else { return false }
    return true
  }
  
  init(left: Int, right: Int, operator: Operator) {
    op = `operator`
    self.left = left
    self.right = right
  }
  
  mutating func append(digit: Int) {
    switch answer {
    case .noAnswer:
      answer = .answer(digit)
    case let .answer(current):
      guard current < 10 else { return }
      answer = .answer(current * 10 + digit)
    }
  }
  
  mutating func erase() {
    guard case let .answer(current) = answer else { return }
    answer = current > 10 ? .answer(current / 10) : .noAnswer
  }
  
  mutating func evaluate() {
    guard case .answer = answer else { return }
    finishedAnswering = true
  }
}

extension Array where Element == Equation {
  var answeredAllCorrectly: Bool {
    self.allSatisfy{ $0.correctlyAnswered && $0.finishedAnswering }
  }
}
