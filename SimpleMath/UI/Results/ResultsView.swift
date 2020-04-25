//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import CornerStacks
import SwiftUI

struct ResultsView: View {
  @Environment(\.horizontalSizeClass) private var hSizeClass
  @EnvironmentObject private var viewModel: SimpleMathViewModel
  @EnvironmentObject private var presentation: ModalPesentation

  var body: some View {
    ZStack {
      Color.background
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .edgesIgnoringSafeArea(.all)
      VStack {
        ResultsHeaderView(correctAnswers: viewModel.correctAnswers, wrongAnswers: viewModel.wrongAnswers)
        ScrollView {
          HStack(spacing: 0) {
            VStack(alignment: .leading) {
              ForEach(self.viewModel.equations.indices, id: \.self) { index in
                ResultRowView(equation: self.viewModel.equations[index])
              }
            }
            Spacer()
          }
          .font(Font.system(size: self.hSizeClass.isRegular ? 34 : 28, weight: .bold, design: .monospaced))
        }
        Spacer()
      }
      .padding(.all, 30)
      TopTrailingHStack {
        ResetButton(action: {
          self.presentation.willDismiss = true
          self.viewModel.reset()
        })
      }
      if viewModel.greatSuccess {
        GreatSuccessOverlayView()
      }
    }
  }
}
