//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct NumbersInputView: View {
  let spacing: CGFloat
  let action: (Int) -> Void
  
  var body: some View {
    VStack {
      HStack(spacing: self.spacing) {
        ForEach(1...3, id: \.self) { index in
          Button(index.description) { self.action(index) }
        }
      }
      HStack(spacing: self.spacing) {
        ForEach(4...6, id: \.self) { index in
          Button(index.description) { self.action(index) }
        }
      }
      HStack(spacing: self.spacing) {
        ForEach(7...9, id: \.self) { index in
          Button(index.description) { self.action(index) }
        }
      }
      HStack(spacing: self.spacing) {
        Button("0") { self.action(0) }
      }
      
    }
    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
  }
}
