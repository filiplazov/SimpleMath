//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import UIKit
import Combine

final class App {
  // swiftlint:disable:next weak_delegate
  private var recognizerDelegate = RecognizerDelegate()
  private var keyboardObserver = KeyboardObserver()
  private var gesture: AnyGestureRecognizer?
  private let storage: Storage
  private var settings: Settings
  weak var window: UIWindow?

  init(window: UIWindow) {
    self.window = window
    storage = UserDefaultsStorage(withKey: App.identifier, modelVersion: App.version)
    settings = StoredSettings(withStorage: storage)
  }

  func startApp() {
    print("App version: \(App.version)")
    let contentView = ContentView()
      .environmentObject(SimpleMathViewModel(settings: settings))
      .environmentObject(SettingsViewModel(settings: settings))
      .environmentObject(Onboarding(withStorage: storage))

    let controller = HostingController(rootView: contentView)
    window?.rootViewController = controller
    UITextField.appearance().tintColor = .primaryText

    gesture = AnyGestureRecognizer(target: window, action: #selector(UIView.endEditing))
    gesture?.requiresExclusiveTouchType = false
    gesture?.cancelsTouchesInView = false
    gesture?.delegate = recognizerDelegate

    keyboardObserver.onShow = { [weak self] in
      guard let gesture = self?.gesture else { return }
      self?.window?.addGestureRecognizer(gesture)
    }

    keyboardObserver.onHide = { [weak self] in
      guard let gesture = self?.gesture else { return }
      self?.window?.removeGestureRecognizer(gesture)
    }
    window?.makeKeyAndVisible()
  }
}

extension App {
  static var version: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }

  static var identifier: String {
    Bundle.main.bundleIdentifier ?? ""
  }
}

private class KeyboardObserver {
  private var subcriptions = Set<AnyCancellable>()
  var onShow: (() -> Void)?
  var onHide: (() -> Void)?

  init() {
    NotificationCenter.default
      .publisher(for: UIResponder.keyboardDidShowNotification)
      .sink(receiveValue: { [weak self] _ in
        self?.onShow?()
      })
      .store(in: &subcriptions)

    NotificationCenter.default
      .publisher(for: UIResponder.keyboardDidHideNotification)
      .sink(receiveValue: { [weak self] _ in
        self?.onHide?()
      })
      .store(in: &subcriptions)

  }
}

class AnyGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}

private final class RecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
      return true
  }
}
