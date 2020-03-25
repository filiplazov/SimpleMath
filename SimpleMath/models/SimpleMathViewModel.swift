//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

final class SimpleMathViewModel: ObservableObject {
  private let defaultEquationCount = 10
  private let upperLimit = 9
  private var audioPlayer = AudioPlayer()
  private var subscriptions = Set<AnyCancellable>()
  private let generator: EquationGenerator
  @Published private(set) var equations: [Equation]
  @Published private(set) var currentEquationIndex = 0
  @Published private(set) var commandsAvailable = false
  @Published private(set) var correctAnswers = 0
  @Published private(set) var progress = 0.0
  @Published private(set) var finished = false
  @Published private(set) var greatSuccess = false
  var wrongAnswers: Int { defaultEquationCount - correctAnswers }

  init() {
    generator = EquationGenerator(count: defaultEquationCount, upperLimit: upperLimit)
    equations = generator.generate()
    $equations
      .map { $0.allSatisfy { $0.finishedAnswering } }
      .assign(to: \.finished, on: self)
      .store(in: &subscriptions)
    $equations
      .map { equations -> Int in equations.filter { $0.correctlyAnswered && $0.finishedAnswering }.count }
      .assign(to: \.correctAnswers, on: self)
      .store(in: &subscriptions)
    $equations
      .map { equations in Double(equations.filter { $0.finishedAnswering }.count) / Double(equations.count) }
      .assign(to: \.progress, on: self)
      .store(in: &subscriptions)
    $equations
      .combineLatest($currentEquationIndex)
      .map { (equations: [Equation], index: Int) -> Bool in equations[index].hasValidAnswer }
      .assign(to: \.commandsAvailable, on: self)
      .store(in: &subscriptions)
    $equations
      .map(\.answeredAllCorrectly)
      .assign(to: \.greatSuccess, on: self)
      .store(in: &subscriptions)
  }
  
  func input(number: Int) {
    equations[currentEquationIndex].append(digit: number)
  }
  
  func erase() {
    equations[currentEquationIndex].erase()
  }
  
  func evaluate() {
    equations[currentEquationIndex].evaluate()
    if greatSuccess {
      audioPlayer.play(sound: .greatSuccess)
    } else if equations[currentEquationIndex].correctlyAnswered {
      audioPlayer.play(sound: .success)
    } else {
      audioPlayer.play(sound: .failure)
    }
    if currentEquationIndex + 1 < equations.count {
      currentEquationIndex += 1
    }
  }
  
  func reset() {
    equations = generator.generate()
    currentEquationIndex = 0
  }
}





