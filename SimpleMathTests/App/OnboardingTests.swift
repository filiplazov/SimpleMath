//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

@testable import SimpleMath
import XCTest

class OnboardingTests: XCTestCase {

  func testInit_loadsPropertiesFromStorage() {
    var storageMock = StorageMock(onboardingBundle: OnboardingBundle(seenSettingsHint: true))
    var onboarding = Onboarding(withStorage: storageMock)
    XCTAssertFalse(
      onboarding.showSettingsHint,
      "`showSettingsHint` should be false because `seenSettingsHint` is set to true"
    )

    storageMock = StorageMock(onboardingBundle: OnboardingBundle(seenSettingsHint: false))
    onboarding = Onboarding(withStorage: storageMock)
    XCTAssertTrue(
      onboarding.showSettingsHint,
      "`showSettingsHint` should be true because `seenSettingsHint` is set to false"
    )
  }

  func testDiscardSettingsHint_setsShowSettingsHintToFalseAndUpdatesStorage() {
    let storageMock = StorageMock(onboardingBundle: OnboardingBundle(seenSettingsHint: false))
    let onboarding = Onboarding(withStorage: storageMock)
    onboarding.discardSettingsHint()
    XCTAssertFalse(
      onboarding.showSettingsHint,
      "showSettingsHint should be set to false after discardSettingsHint is called"
    )
    XCTAssertEqual(
      storageMock.onboardingBundle,
      OnboardingBundle(seenSettingsHint: true),
      "the storage should be updated with the changed onboarding bundle where seenSettingsHint is true"
    )
  }

  func testDiscardSettingsHint_doesNothingIfShowSettingsHintWasFalse() {
    let storageMock = StorageMock(onboardingBundle: OnboardingBundle(seenSettingsHint: true))
    let onboarding = Onboarding(withStorage: storageMock)

    XCTAssertFalse(
      onboarding.showSettingsHint,
      "showSettingsHint should still be false after discardSettingsHint is called"
    )
    XCTAssertEqual(
      storageMock.onboardingBundle,
      OnboardingBundle(seenSettingsHint: true),
      "the storage should be not be updated"
    )
  }

}
