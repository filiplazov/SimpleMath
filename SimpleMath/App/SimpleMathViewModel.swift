//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine
import UIKit

final class SimpleMathViewModel: ObservableObject {
  private var subscriptions = Set<AnyCancellable>()
  private var audioEngine: AudioEngine
  private weak var settings: Settings?
  private var areSoundsEnabled = false
  private var equationSettings: EquationSettings?
  let equationsFactory: EquationsFactory
  @Published private(set) var equations: [Equation] = []
  @Published private(set) var currentEquationIndex = 0
  @Published private(set) var commandsAvailable = false
  @Published private(set) var operandDigitCount = 0
  @Published private(set) var answerDigitCount = 0
  @Published private(set) var correctAnswers = 0
  @Published private(set) var progress = 0.0
  @Published private(set) var finished = false
  @Published private(set) var greatSuccess = false
  var wrongAnswers: Int { equations.count - correctAnswers }

  init(settings: Settings, audioPlayer: AudioEngine = AudioPlayer(), equationsFactory: EquationsFactory = EquationsFactoryImp()) {
    self.settings = settings
    self.audioEngine = audioPlayer
    self.equationsFactory = equationsFactory
    setupSubscriptions()
  }
  
  private func setupSubscriptions() {
    settings?.currentSettings
      .map(\.areSoundsEnabled)
      .assign(to: \.areSoundsEnabled, on: self)
      .store(in: &subscriptions)
    settings?.currentSettings
      .map(\.equationSettings)
      .removeDuplicates()
      .sink(receiveValue: makeNewEquations(withEquationSettings:))
      .store(in: &subscriptions)
      
    $equations
      .filter { !$0.isEmpty }
      .map { $0.allSatisfy { $0.finishedAnswering } }
      .assign(to: \.finished, on: self)
      .store(in: &subscriptions)
    $equations
      .map { equations -> Int in equations.filter { $0.correctlyAnswered && $0.finishedAnswering }.count }
      .assign(to: \.correctAnswers, on: self)
      .store(in: &subscriptions)
    $equations
      .filter { !$0.isEmpty }
      .map { equations in Double(equations.filter { $0.finishedAnswering }.count) / Double(equations.count) }
      .assign(to: \.progress, on: self)
      .store(in: &subscriptions)
    $equations
      .filter { !$0.isEmpty }
      .combineLatest($currentEquationIndex)
      .map { (equations: [Equation], index: Int) -> Bool in equations[index].hasValidAnswer }
      .assign(to: \.commandsAvailable, on: self)
      .store(in: &subscriptions)
    $equations
      .filter { !$0.isEmpty }
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
    if areSoundsEnabled {
      if greatSuccess {
        audioEngine.play(sound: .greatSuccess)
      } else if equations[currentEquationIndex].correctlyAnswered {
        audioEngine.play(sound: .success)
      } else {
        audioEngine.play(sound: .failure)
      }
    }
    if currentEquationIndex + 1 < equations.count {
      currentEquationIndex += 1
    }
  }
  
  func reset() {
    guard let equationSettings = self.equationSettings else { return }
    makeNewEquations(withEquationSettings: equationSettings)
  }
  
  private func makeNewEquations(withEquationSettings equationSettings: EquationSettings) {
    self.equationSettings = equationSettings
    currentEquationIndex = 0
    let result = equationsFactory.makeEquations(usingSettings: equationSettings)
    equations = result.equations
    operandDigitCount = result.maxOperandDigits
    answerDigitCount = result.maxAnswerDigits
  }
}







