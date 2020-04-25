//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct DigitRangeSettingSectionView: View {
  @EnvironmentObject private var viewModel: SettingsViewModel
  @Environment(\.horizontalSizeClass) private var hSizeClass

  var body: some View {
    VStack(spacing: 8) {
      HStack {
        TextField(
          "",
          text: Binding<String>(
            get: { self.viewModel.minRangeText },
            set: viewModel.updateMinRange(text:)
          )
        )
          .modifier(DigitTextField(isValid: viewModel.isRangeValid))
        Spacer()
        Image(withSymbol: .leftArrow)
          .font(.system(size: hSizeClass.isRegular ? 26 : 20, weight: .bold, design: .monospaced))
        Spacer()
        Text("X")
          .font(.system(size: hSizeClass.isRegular ? 28 : 20, weight: .heavy, design: .monospaced))
        Spacer()
        Image(withSymbol: .rightArrow)
          .font(.system(size: hSizeClass.isRegular ? 26 : 20, weight: .bold, design: .monospaced))
        Spacer()
        TextField(
          "", text: Binding<String>(
            get: { self.viewModel.maxRangeText },
            set: { self.viewModel.updateMaxRange(text: $0)}
          )
        )
          .modifier(DigitTextField(isValid: viewModel.isRangeValid))
      }

      HStack {
        Text("X + X = ")
        Text("  ")
          .frame(width: hSizeClass.isRegular ? 54 : 40)
          .background(Color.unanswered)
          .clipShape(Capsule())

      }
      .font(.system(size: hSizeClass.isRegular ? 24 :  16, weight: .bold, design: .monospaced))
      .opacity(0.6)
    }
    .animation(nil)
    .padding()
    .modifier(SettingCell(maxWidth: .infinity))
  }
}

private struct DigitTextField: ViewModifier {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  var isValid: Bool

  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.center)
      .keyboardType(.numberPad)
      .font(.system(size: hSizeClass.isRegular ? 40 : 30))
      .frame(width: hSizeClass.isRegular ? 80 : 60, alignment: .center)
      .background(
        RoundedRectangle(cornerRadius: 8, style: .continuous)
          .stroke(lineWidth: 2)
          .foregroundColor(isValid ? .settingTextFieldBorder : .settingTextFieldBorderInvalid)
    )
  }

}
