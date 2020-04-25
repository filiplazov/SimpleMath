//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

final class SettingsViewModel: ObservableObject {
  private weak var settings: Settings?
  private var subscriptions = Set<AnyCancellable>()
  @Published private var minRange: Int?
  @Published private var maxRange: Int?
  @Published private var enabledEquationTypes = Set<EquationType>()
  @Published private(set) var minRangeText = ""
  @Published private(set) var maxRangeText = ""
  @Published private(set) var isRangeValid = true
  @Published private(set) var numberOfEquations = 0
  @Published private(set) var additionEnabled = false
  @Published private(set) var subtractonEnabled = false
  @Published private(set) var multiplicationEnabled = false
  @Published private(set) var divisionEnabled = false
  @Published var areSoundsEnabled = true

  init(settings: Settings) {
    self.settings = settings
    setupSubscriptions()
  }

  private func setupSubscriptions() {
    settings?.currentSettings
      .sink(receiveValue: { [weak self] settingsBundle in
        self?.minRange = settingsBundle.minimumDigit
        self?.maxRange = settingsBundle.maximumDigit
        self?.enabledEquationTypes = Set(settingsBundle.equationTypes)
        self?.numberOfEquations = settingsBundle.equationsCount
        self?.areSoundsEnabled = settingsBundle.areSoundsEnabled
      })
      .store(in: &subscriptions)
    $minRange
      .map { $0?.description ?? "" }
      .assign(to: \.minRangeText, on: self)
      .store(in: &subscriptions)
    $maxRange
      .map { $0?.description ?? "" }
      .assign(to: \.maxRangeText, on: self)
      .store(in: &subscriptions)
    $minRange
      .combineLatest($maxRange)
      .map({ min, max in
        guard let min = min, let max = max else { return false }
        return min < max
      })
      .assign(to: \.isRangeValid, on: self)
      .store(in: &subscriptions)
    $enabledEquationTypes
      .map { $0.contains(.addition) }
      .assign(to: \.additionEnabled, on: self)
      .store(in: &subscriptions)
    $enabledEquationTypes
      .map { $0.contains(.subtraction) }
      .assign(to: \.subtractonEnabled, on: self)
      .store(in: &subscriptions)
    $enabledEquationTypes
      .map { $0.contains(.multiplication) }
      .assign(to: \.multiplicationEnabled, on: self)
      .store(in: &subscriptions)
    $enabledEquationTypes
      .map { $0.contains(.division) }
      .assign(to: \.divisionEnabled, on: self)
      .store(in: &subscriptions)
  }

  func updateMinRange(text: String) {
    minRange = Int(text).flatMap { number in number < 100 && number >= 0 ? number : minRange }
  }

  func updateMaxRange(text: String) {
    maxRange = Int(text).flatMap { number in number < 100 && number >= 0 ? number : maxRange }
  }

  func decreaseNumberOfEquations() {
    guard numberOfEquations > 5 else { return }
    numberOfEquations -= 1
  }

  func increaseNumberOfEquations() {
    guard numberOfEquations < 30 else { return }
    numberOfEquations += 1
  }

  func enableEquation(type: EquationType) {
    enabledEquationTypes.insert(type)
  }

  func disableEquation(type: EquationType) {
    guard enabledEquationTypes.count > 1 && enabledEquationTypes.contains(type) else { return }
    enabledEquationTypes.remove(type)
  }

  func updateSoundsEnabled(to areEnabled: Bool) {
    areSoundsEnabled = areEnabled
  }

  func commitChanges() {
    guard let min = minRange, let max = maxRange else { return }
    let settingsBundle = SettingsBundle(
      minimumDigit: min,
      maximumDigit: max,
      equationsCount: numberOfEquations,
      equationTypes: enabledEquationTypes,
      areSoundsEnabled: areSoundsEnabled
    )
    settings?.updateSettings(bundle: settingsBundle)
  }
}
