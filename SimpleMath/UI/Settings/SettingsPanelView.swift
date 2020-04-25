//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct SettingsPanelView: View {
  @EnvironmentObject private var viewModel: SettingsViewModel
  @Environment(\.horizontalSizeClass) private var hSizeClass
  private let cellSpacing: CGFloat = 12
  private var width: CGFloat { hSizeClass.isRegular ? 740 : CGFloat.screenWidth - 48 }
  private var height: CGFloat? {  hSizeClass.isRegular ? nil : 380 + (CGFloat.screenHeight > 568 ? 104 : 0)}
  @Binding var show: Bool

  var body: some View {
    ZStack {
      Color.black
        .opacity(show ? 0.0001 : 0) // invisible to the eye but enough to make it hittable
        .edgesIgnoringSafeArea(.all)
        .onTapGesture(perform: {
          guard self.viewModel.isRangeValid else { return }
          withAnimation {
            self.viewModel.commitChanges()
            self.show = false
          }
        })

      if hSizeClass.isRegular {
        HStack(alignment: .top, spacing: cellSpacing) {
          VStack(spacing: cellSpacing) {
            DigitRangeSettingSectionView()
            NumberOfEquationsSettingView(isVisible: show)
          }
          VStack(spacing: cellSpacing) {
            EquationTypeSettingView()
            SoundToggleSettingView()
          }
        }
        .padding()
        .animation(nil)
        .modifier(SettingPanel(isVisible: show, maxWidth: width, maxHeight: height))
      } else {
        ScrollView {
          VStack(spacing: cellSpacing) {
            DigitRangeSettingSectionView()
            NumberOfEquationsSettingView(isVisible: show)
            EquationTypeSettingView()
            SoundToggleSettingView()
          }
          .padding()
          .animation(nil)
        }
        .modifier(SettingPanel(isVisible: show, maxWidth: width, maxHeight: height))
      }
    }
    .animation(Animation.easeInOut(duration: 0.3).delay(0.12))
  }
}

private struct SettingPanel: ViewModifier {
  var isVisible: Bool
  var maxWidth: CGFloat
  var maxHeight: CGFloat?

  func body(content: Content) -> some View {
    content
      .foregroundColor(.primaryText)
      .frame(maxWidth: maxWidth, maxHeight: maxHeight)
      .background(Color.settingPanelBackgroundBase.opacity(0.6))
      .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
      .opacity(isVisible ? 1: 0)
  }
}
