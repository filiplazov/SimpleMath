//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

struct EquationsFactoryImp: EquationsFactory {
  func makeEquations(usingSettings settings: EquationSettings) -> GeneratedResult {
    let maxAnswerDigits = maxAnswerDigitCount(settings: settings)
    let maxOperandDigits = settings.maximumDigit.description.count
    let types = Array(settings.equationTypes).shuffled()
    let equations = (0..<settings.equationsCount)
      .map({ (index: Int) -> Equation in
          let type = types[index % types.count]
          return type.makeEquation(setting: settings, maxAnswerDigits: maxAnswerDigits)
      })
    return GeneratedResult(equations: equations, maxOperandDigits: maxOperandDigits, maxAnswerDigits: maxAnswerDigits)
  }

  private func maxAnswerDigitCount(settings: EquationSettings) -> Int {
    let maxAnswer: Int
    if settings.equationTypes.contains(.multiplication) {
      maxAnswer = settings.maximumDigit * settings.maximumDigit
    } else if settings.equationTypes.contains(.addition) {
      maxAnswer = settings.maximumDigit + settings.maximumDigit
    } else {
      maxAnswer = settings.maximumDigit
    }
    return maxAnswer.description.count
  }
}

private extension EquationType {
  func makeEquation(setting: EquationSettings, maxAnswerDigits: Int) -> Equation {
    switch self {
    case .addition: return makeAddition(settings: setting, maxAnswerDigits: maxAnswerDigits)
    case .subtraction: return makeSubtraction(settings: setting, maxAnswerDigits: maxAnswerDigits)
    case .multiplication: return makeMultiplication(settings: setting, maxAnswerDigits: maxAnswerDigits)
    case .division : return makeDivision(settings: setting, maxAnswerDigits: maxAnswerDigits)
    }
  }

  private func makeAddition(settings: EquationSettings, maxAnswerDigits: Int) -> Equation {
    let left = Int.random(in: settings.minimumDigit...settings.maximumDigit)
    let right = Int.random(in: settings.minimumDigit...settings.maximumDigit)
    return Equation(left: left, right: right, operator: .add, answerDigitLimit: maxAnswerDigits)
  }

  private func makeSubtraction(settings: EquationSettings, maxAnswerDigits: Int) -> Equation {
    let right = Int.random(in: settings.minimumDigit...settings.maximumDigit)
    let left = Int.random(in: right...settings.maximumDigit)
    return Equation(left: left, right: right, operator: .subtract, answerDigitLimit: maxAnswerDigits)
  }

  private func makeMultiplication(settings: EquationSettings, maxAnswerDigits: Int) -> Equation {
    let left = Int.random(in: settings.minimumDigit...settings.maximumDigit)
    let right = Int.random(in: settings.minimumDigit...settings.maximumDigit)
    return Equation(left: left, right: right, operator: .multiply, answerDigitLimit: maxAnswerDigits)
  }

  private func makeDivision(settings: EquationSettings, maxAnswerDigits: Int) -> Equation {
    // we group the possible dividends by prime and nonprime array of numbers
    let grouping = Dictionary(grouping: (settings.minimumDigit...settings.maximumDigit), by: \.isPrime)
    let left: Int
    if grouping[true] == nil {
      // if there are no prime numbers, than pick from one of the nonprime numbers
      left = grouping[false]?.randomElement() ?? settings.maximumDigit
    } else {
      // if `0`, get a prime number, otherwise get a nonprime, nonprime numbers have twice the chance,
      // this reduces boring equations
      let lottery = Int.random(in: 0...2)
      left = grouping[lottery == 0]?.randomElement() ?? settings.maximumDigit
    }
    // avoid division by 0
    let minDigit = settings.minimumDigit == 0 ? 1 : settings.minimumDigit
    let right: Int
    if left == 0 {
      // if `0` is the dividend, divide by any number in the valid range
      right = Int.random(in: minDigit...settings.maximumDigit)
    } else {
      // otherwise, pick a random divisor that results in a division without remainder
      let possibleDivisors = (minDigit...left).filter { left % $0 == 0 }
      right = possibleDivisors.randomElement() ?? settings.maximumDigit
    }
    return Equation(left: left, right: right, operator: .divide, answerDigitLimit: maxAnswerDigits)
  }
}
