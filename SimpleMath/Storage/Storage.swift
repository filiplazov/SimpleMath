//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation

protocol Storage: AnyObject {
  func store(settingsBundle: SettingsBundle)
  func loadSettingsBundle() -> SettingsBundle
  func store(onboardingBundle: OnboardingBundle)
  func loadOnboardingBundle() -> OnboardingBundle
}


