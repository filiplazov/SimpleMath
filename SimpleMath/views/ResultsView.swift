//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import CornerStacks
import SwiftUI

struct ResultsView: View {
  @ObservedObject var viewModel: SimpleMathViewModel
  
  var body: some View {
    ZStack {
      VStack {
        ResultsHeaderView(correctAnswers: viewModel.correctAnswers, wrongAnswers: viewModel.wrongAnswers)
        HStack {
          VStack(alignment: .leading) {
            ForEach(self.viewModel.equations.indices, id: \.self) { index in
              ResultRowView(equation: self.viewModel.equations[index])
            }
          }
          Spacer()
        }
        Spacer()
      }
      .padding(.all, 30)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .background(Color(#colorLiteral(red: 0.4739681945, green: 0.1025257594, blue: 0.4670193102, alpha: 1)))
      TopTrailingHStack {
        ResetButton(action: self.viewModel.reset)
      }
      if viewModel.greatSuccess {
        GreatSuccessOverlayView()
      }
    }
  }
}
