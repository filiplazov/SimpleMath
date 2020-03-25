//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct NumbersInputView: View {
  let action: (Int) -> Void
  
  var body: some View {
    VStack {
      HStack(spacing: 100) {
        ForEach(1...3, id: \.self) { index in
          Button(index.description) { self.action(index) }
        }
      }
      HStack(spacing: 100) {
        ForEach(4...6, id: \.self) { index in
          Button(index.description) { self.action(index) }
        }
      }
      HStack(spacing: 100) {
        ForEach(7...9, id: \.self) { index in
          Button(index.description) { self.action(index) }
        }
      }
      HStack(spacing: 100) {
        Button("0") { self.action(0) }
      }
      
    }
    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
    .font(Font.system(size: 90, weight: .heavy, design: .monospaced))
    .padding([.leading, .trailing], 30)
  }
}
