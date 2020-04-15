//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Combine

final class ModalPesentation: ObservableObject {
  private var subscriptions = Set<AnyCancellable>()
  private var presentationChange = PassthroughSubject<Bool, Never>()
  private var dismissHandler: () -> Void = { }
  
  @Published var isPresented = false {
    didSet { presentationChange.send(isPresented) }
  }
  var willDismiss = false
  
  init() {
    presentationChange
      .removeDuplicates()
      .scan((false, false), { current, new  in (current.1, new) }) // change tuple (wasVisible, isVisible)
      .filter({ from, to in from && !to }) // only allow events where modal was visible and now it is not
      .map { _ in () } // ignore the boolean and just publish void
      .filter(allowEvent) // prevent the event if `willDismiss` was explicitly set to true
      .sink(receiveValue: { [weak self] in
        self?.dismissHandler()
      })
      .store(in: &subscriptions)
  }
  
  func onModalGestureDismiss(_ handler: @escaping () -> Void) {
    dismissHandler = handler
  }
  
  private func allowEvent() -> Bool {
    if willDismiss {
      willDismiss = false
      return false
    }
    return true
  }
}
