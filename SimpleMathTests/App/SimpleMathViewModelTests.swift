//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine
@testable import SimpleMath
import XCTest

class SimpleMathViewModelTests: XCTestCase {

  func testInit_equationsAreGeneratedUsingCorrectSettings() {
    let expectedEquations: [Equation] = [
      Equation(left: 1, right: 3, operator: .add, answerDigitLimit: 2),
      Equation(left: 1, right: 5, operator: .multiply, answerDigitLimit: 2),
      Equation(left: 4, right: 2, operator: .subtract, answerDigitLimit: 2),
      Equation(left: 6, right: 3, operator: .divide, answerDigitLimit: 2)
    ]
    let expectedOperandDigitCount = 1
    let expectedAnswerDigitCount = 2
    let expectedEquationSettings = SettingsBundle.default.equationSettings
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(
        equations: expectedEquations,
        maxOperandDigits: expectedOperandDigitCount,
        maxAnswerDigits: expectedAnswerDigitCount
      )
    }
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: AudioEngineMock(),
      equationsFactory: factoryMock
    )
    
    XCTAssertEqual(viewModel.equations, expectedEquations,
                   "created equations should be the expected ones from the equation factory generated result")
    XCTAssertEqual(viewModel.currentEquationIndex, 0, "index always starts at 0")
    XCTAssertEqual(viewModel.operandDigitCount, expectedOperandDigitCount,
                   "the operand digit count should be the same from the equation factory generated result")
    XCTAssertEqual(viewModel.answerDigitCount, expectedAnswerDigitCount,
                   "the answer digit count should be the same from the equation factory generated result")
    XCTAssertEqual(factoryMock.equationSettings, expectedEquationSettings,
                   "the factory should use the settings it was called with to generate the equations")
  }
  
  func testInputNumber_correctlyAddsDigitOnCurrentEquation() {
    let equations: [Equation] = [ .onePlusOne, .onePlusOne, .onePlusOne]
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(equations: equations, maxOperandDigits: 1, maxAnswerDigits: 1)
    }
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: AudioEngineMock(),
      equationsFactory:
      factoryMock
    )
    XCTAssertFalse(viewModel.commandsAvailable, "before inputing any numbers commands should be disabled")
    viewModel.input(number: 2)
    XCTAssertTrue(viewModel.commandsAvailable, "after inputing a number the commands should be enabled")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "", "expected no answer")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "", "expected no answer")
  }
  
  func testErase_correctlyRemovesDigitFromCurrentEquation() {
    let equations: [Equation] = [ .onePlusOne, .onePlusOne, .onePlusOne]
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(equations: equations, maxOperandDigits: 1, maxAnswerDigits: 1)
    }
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: AudioEngineMock(),
      equationsFactory:
      factoryMock
    )
    XCTAssertFalse(viewModel.commandsAvailable, "before inputing any numbers commands should be disabled")
    viewModel.input(number: 2)
    XCTAssertTrue(viewModel.commandsAvailable, "after inputing a number the commands should be enabled")
    viewModel.erase()
    XCTAssertFalse(viewModel.commandsAvailable, "after erasing the last digit the commands should be disabled")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "", "expected no answer")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "", "expected no answer")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "", "expected no answer")
  }
  
  func testEvaluate_soundsEnabled_correctlyEvaluatesEquationAndPlaysSoundBasedOnEvaluation() {
    let equations: [Equation] = [ .onePlusOne, .onePlusOne, .onePlusOne]
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(equations: equations, maxOperandDigits: 1, maxAnswerDigits: 1)
    }
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let audioEngineMock = AudioEngineMock()
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: audioEngineMock,
      equationsFactory:
      factoryMock
    )
    XCTAssertFalse(viewModel.commandsAvailable, "before inputing any numbers commands should be disabled")
    viewModel.input(number: 2)
    XCTAssertTrue(viewModel.commandsAvailable, "after inputing a number the commands should be enabled")
    viewModel.evaluate()
    XCTAssertFalse(viewModel.commandsAvailable, "after evaluating an equation the commands should be disabled")
    viewModel.input(number: 1)
    XCTAssertTrue(viewModel.commandsAvailable, "after inputing a number the commands should be enabled")
    viewModel.evaluate()
    XCTAssertFalse(viewModel.commandsAvailable, "after evaluating an equation the commands should be disabled")
    XCTAssertEqual(viewModel.currentEquationIndex, 2, "after evaluating 2 equations the index should be at 2 (third)")
    XCTAssertEqual(viewModel.correctAnswers, 1, "after correctly evaluating single equation, correct answers should be 1")
    XCTAssertEqual(viewModel.progress, 2/3, "after evaluating 2 out fo 3 equations, progress should be 2/3 (in decimal)")
    XCTAssertFalse(viewModel.finished, "finished should be false since not all equations have been evaluated")
    XCTAssertFalse(viewModel.greatSuccess, "great seccess should be false since not all equations have been evaluated")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[0].finishedAnswering, "first equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "1", "expected current answer to be 1")
    XCTAssertTrue(viewModel.equations[1].finishedAnswering, "second equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[2].finishedAnswering, "third equation should have finished answering false")
    XCTAssertEqual(
      audioEngineMock.playedSounds, [.success, .failure],
      "expected sounds played are `success` after first equation evaluated correctly, `faulure` after second incorrectly"
    )
  }
  
  func testEvaluate_soundsEnabled_correctlyEvaluatesAllEquations() {
    let equations: [Equation] = [ .onePlusOne, .onePlusOne, .onePlusOne]
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(equations: equations, maxOperandDigits: 1, maxAnswerDigits: 1)
    }
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let audioEngineMock = AudioEngineMock()
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: audioEngineMock,
      equationsFactory:
      factoryMock
    )
    viewModel.input(number: 2)
    viewModel.evaluate()
    viewModel.input(number: 2)
    viewModel.evaluate()
    viewModel.input(number: 2)
    viewModel.evaluate()
    XCTAssertEqual(viewModel.currentEquationIndex, 2, "after evaluating all equations the index should be at 2 (last)")
    XCTAssertEqual(viewModel.correctAnswers, 3, "after correctly evaluating 3 equations, correct answers should be 3")
    XCTAssertEqual(viewModel.progress, 1, "after evaluating all equations, progress should be 1 (100%)")
    XCTAssertTrue(viewModel.finished, "finished should be true since all equations have been evaluated")
    XCTAssertTrue(viewModel.greatSuccess, "great seccess should be true since all equations were correctly evaluated")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[0].finishedAnswering, "first equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[1].finishedAnswering, "second equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[2].finishedAnswering, "third equation should have finished answering true")
    XCTAssertEqual(
      audioEngineMock.playedSounds, [.success, .success, .greatSuccess],
      "expected sounds played are `success` for the first two correcrly evaluated equations, and `greatSuccess` at the end"
    )
  }
  
  func testEvaluate_soundsEnabled_incorrectlyEvaluatesAllEquations() {
    let equations: [Equation] = [ .onePlusOne, .onePlusOne, .onePlusOne]
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(equations: equations, maxOperandDigits: 1, maxAnswerDigits: 1)
    }
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let audioEngineMock = AudioEngineMock()
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: audioEngineMock,
      equationsFactory:
      factoryMock
    )
    viewModel.input(number: 1)
    viewModel.evaluate()
    viewModel.input(number: 1)
    viewModel.evaluate()
    viewModel.input(number: 1)
    viewModel.evaluate()
    XCTAssertEqual(viewModel.currentEquationIndex, 2, "after evaluating all equations the index should be at 2 (last)")
    XCTAssertEqual(viewModel.correctAnswers, 0, "after correctly evaluating 0 equations, correct answers should be 0")
    XCTAssertEqual(viewModel.progress, 1, "after evaluating all equations, progress should be 1 (100%)")
    XCTAssertTrue(viewModel.finished, "finished should be true since all equations have been evaluated")
    XCTAssertFalse(viewModel.greatSuccess, "great seccess should be false since not all equations were correctly evaluated")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "1", "expected current answer to be 1")
    XCTAssertTrue(viewModel.equations[0].finishedAnswering, "first equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "1", "expected current answer to be 1")
    XCTAssertTrue(viewModel.equations[1].finishedAnswering, "second equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "1", "expected current answer to be 1")
    XCTAssertTrue(viewModel.equations[2].finishedAnswering, "third equation should have finished answering true")
    XCTAssertEqual(
      audioEngineMock.playedSounds, [.failure, .failure, .failure],
      "expected sounds played are `failure` for all equations since all evaluated incorrectly")
  }
  
  func testEvaluate_soundsDisabled_correctlyEvaluatesAllEquationsButNoSoundsPlayed() {
    let equations: [Equation] = [ .onePlusOne, .onePlusOne, .onePlusOne]
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(equations: equations, maxOperandDigits: 1, maxAnswerDigits: 1)
    }
    let settingsBundle = SettingsBundle.default.set(\.areSoundsEnabled, to: false)
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(settingsBundle)
    let audioEngineMock = AudioEngineMock()
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: audioEngineMock,
      equationsFactory:
      factoryMock
    )
    viewModel.input(number: 2)
    viewModel.evaluate()
    viewModel.input(number: 2)
    viewModel.evaluate()
    viewModel.input(number: 2)
    viewModel.evaluate()
    XCTAssertTrue(audioEngineMock.playedSounds.isEmpty, "when sounds are disabled no sounds should be played")
  }
  
  func testReset_reCreatesEquationsSetsIndexToZeroAndResetsOtherParameters() {
    let equations: [Equation] = [ .onePlusOne, .onePlusOne, .onePlusOne]
    let factoryMock = EquationsFactoryMock {
      GeneratedResult(equations: equations, maxOperandDigits: 1, maxAnswerDigits: 1)
    }
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = .just(.default)
    let audioEngineMock = AudioEngineMock()
    let viewModel = SimpleMathViewModel(
      settings: settingsMock,
      audioPlayer: audioEngineMock,
      equationsFactory:
      factoryMock
    )
    viewModel.input(number: 2)
    viewModel.evaluate()
    viewModel.input(number: 2)
    viewModel.evaluate()
    viewModel.input(number: 2)
    viewModel.evaluate()
    XCTAssertEqual(viewModel.currentEquationIndex, 2, "after evaluating all equations the index should be at 2 (last)")
    XCTAssertEqual(viewModel.correctAnswers, 3, "after correctly evaluating 3 equations, correct answers should be 3")
    XCTAssertEqual(viewModel.progress, 1, "after evaluating all equations, progress should be 1 (100%)")
    XCTAssertTrue(viewModel.finished, "finishe should be true since all equations have been evaluated")
    XCTAssertTrue(viewModel.greatSuccess, "great seccess should be true since all equations were correctly evaluated")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[0].finishedAnswering, "first equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[1].finishedAnswering, "second equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[2].finishedAnswering, "third equation should have finished answering true")
    
    viewModel.reset()
    
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[0].finishedAnswering, "first equation should have finished answering false after reset")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[1].finishedAnswering, "second equation should have finished answering false after reset")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[2].finishedAnswering, "third equation should have finished answering false after reset")
    XCTAssertEqual(viewModel.equations, equations, "after reset the factory will regenerate new equations")
    XCTAssertEqual(viewModel.currentEquationIndex, 0, "after reset the index should be set to 0")
    XCTAssertEqual(viewModel.correctAnswers, 0, "after reset the correct answers should be 0")
    XCTAssertEqual(viewModel.progress, 0, "after resetting, progress should be 0")
    XCTAssertFalse(viewModel.finished, "finished should be false after a reset")
    XCTAssertFalse(viewModel.greatSuccess, "great seccess should be after a reset")
  }
  
  func testSettings_newSettingsPublishedThatChangeEquationSettingsWillResetCurrentEquations() {
    let settingsPublisher = CurrentValueSubject<SettingsBundle, Never>(.default)
    let settingsMock = SettingsMock()
    settingsMock.currentSettings = settingsPublisher.eraseToAnyPublisher()
    let viewModel = SimpleMathViewModel(settings: settingsMock, audioPlayer: AudioEngineMock())
    XCTAssertEqual(viewModel.equations.count, 10, "default settings bundle has equations count set to 10")
    viewModel.input(number: 2)
    viewModel.evaluate()
    viewModel.input(number: 1)
    viewModel.evaluate()
    XCTAssertEqual(viewModel.currentEquationIndex, 2, "after evaluating 2 equations the index should be at 2 (third)")
    XCTAssertEqual(viewModel.progress, 2/10, "after evaluating 2 out fo 9 equations, progress should be 2/3 (in decimal)")
    XCTAssertFalse(viewModel.finished, "finished should be false since not all equations have been evaluated")
    XCTAssertFalse(viewModel.greatSuccess, "great seccess should be false since not all equations have been evaluated")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "2", "expected current answer to be 2")
    XCTAssertTrue(viewModel.equations[0].finishedAnswering, "first equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "1", "expected current answer to be 1")
    XCTAssertTrue(viewModel.equations[1].finishedAnswering, "second equation should have finished answering true")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[2].finishedAnswering, "third equation should have finished answering false")
    
    settingsPublisher.value = SettingsBundle.default.set(\.equationsCount, to: 5)
    
    XCTAssertEqual(viewModel.equations.count, 5, "new settings bundle has equations count set to 10")
    XCTAssertEqual(viewModel.equations[0].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[0].finishedAnswering, "first equation should have finished answering false after reset")
    XCTAssertEqual(viewModel.equations[1].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[1].finishedAnswering, "second equation should have finished answering false after reset")
    XCTAssertEqual(viewModel.equations[2].currentAnswerText, "", "expected no answer")
    XCTAssertFalse(viewModel.equations[2].finishedAnswering, "third equation should have finished answering false after reset")
    XCTAssertEqual(viewModel.currentEquationIndex, 0, "after settings update the index should be set to 0")
    XCTAssertEqual(viewModel.correctAnswers, 0, "after settings update the correct answers should be 0")
    XCTAssertEqual(viewModel.progress, 0, "after settings update, progress should be 0")
    XCTAssertFalse(viewModel.finished, "finished should be false after settings update")
    XCTAssertFalse(viewModel.greatSuccess, "great seccess should be after settings update")
  }

}

extension Equation {
  static let onePlusOne = Equation(left: 1, right: 1, operator: .add, answerDigitLimit: 1)
}
