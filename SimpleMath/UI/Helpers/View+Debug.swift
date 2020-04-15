//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

#if DEBUG
extension View {
  func blackBorder() -> some View {
    self.border(Color.black)
  }
  func redBorder() -> some View {
    self.border(Color.red)
  }
  func greenBorder() -> some View {
    self.border(Color.green)
  }
  
  func blackBackground() -> some View {
    self.background(Color.black)
  }
  
  func redBackground() -> some View {
    self.background(Color.red)
  }
  
  func greenBackground() -> some View {
    self.background(Color.green)
  }
}

// Credit: Geek & Dad,
// https://geekanddad.wordpress.com/2020/02/13/swiftui-tiny-bits-little-view-extension-to-log-to-the-console/
extension View {
  func printMessage(_ msg: Any..., separator: String = " ", terminator: String = "\n") -> some View {
      for m in msg {
        print(m, separator, terminator: "")
      }
      print()
      return self
  }
}

extension View {
  func printFrame(label: String) -> some View {
    self
      .background(
        GeometryReader { proxy in
          Color.clear
            .printMessage(label, proxy.frame(in: .global))
      })
  }
}
#endif

