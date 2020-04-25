//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

final class StorageMock: Storage {
  var settingsBundle: SettingsBundle
  var onboardingBundle: OnboardingBundle

  init(settingsBundle: SettingsBundle = .default, onboardingBundle: OnboardingBundle = .default) {
    self.settingsBundle = settingsBundle
    self.onboardingBundle = onboardingBundle
  }

  func store(settingsBundle: SettingsBundle) {
    self.settingsBundle = settingsBundle
  }

  func loadSettingsBundle() -> SettingsBundle {
    settingsBundle
  }

  func store(onboardingBundle: OnboardingBundle) {
    self.onboardingBundle = onboardingBundle
  }

  func loadOnboardingBundle() -> OnboardingBundle {
    onboardingBundle
  }
}
