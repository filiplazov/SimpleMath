//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

final class Onboarding: ObservableObject {
  private let storage: Storage
  @Published private(set) var showSettingsHint: Bool
  
  init(withStorage storage: Storage) {
    self.storage = storage
    showSettingsHint = !storage.loadOnboardingBundle().seenSettingsHint
  }
  
  func discardSettingsHint() {
    guard showSettingsHint else { return }
    showSettingsHint = false
    let bundle = OnboardingBundle(seenSettingsHint: !showSettingsHint)
    storage.store(onboardingBundle: bundle)
  }
}
