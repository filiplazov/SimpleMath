//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import SwiftUI

struct Container: View {
  var body: some View {
    ZStack {
      MiniDeviceView(width: 100, animate: true)
    }
  }
}

struct MiniDeviceView: View {
  private let timer = Timer.publish(every: 1.6, on: .main, in: .common).autoconnect()
  @State private var isDrifted = false
  private let height: CGFloat
  private var inputMockupColor = Color.miniDeviceInputMockupGray
  private var correctAnswersMockupColor = Color.miniDeviceInputMockupGreen
  private var equationRowColor = Color.primaryText
  var width: CGFloat
  var animate: Bool

  init(width: CGFloat, animate: Bool) {
    self.width = width
    self.animate = animate
    height = width * 2
  }
  var body: some View {
    ZStack {
      IPhoneView(width: width, height: height, screenColor: Color.background)
      equationsMockup()
      .animation(.easeInOut(duration: 1.5))
      .onReceive(timer) { _ in
        guard self.animate else { return }
        self.isDrifted.toggle()
      }
      inputMockup()
    }
    .drawingGroup()
    .frame(width: width, height: height)
  }

  private func square(size: CGSize, color: Color) -> some View {
    Rectangle()
      .fill(color)
      .frame(width: size.width, height: size.height)
  }

  private func squareRow(squareSize: CGSize, count: Int, color: Color) -> some View {
    HStack(spacing: width / 15 ) {
      ForEach(0..<count) { _ in
        self.square(size: squareSize, color: color)
      }
    }
  }

  private func inputMockup() -> some View {
    let squareSize = CGSize(width: width * 0.08, height: width * 0.08)
    return Group {

      ForEach(0..<3) { index in
        self.squareRow(squareSize: squareSize, count: 3, color: self.inputMockupColor)
          .offset(x: 0, y: self.height * (0.12 + CGFloat(index) * 0.07))
      }

      squareRow(squareSize: squareSize, count: 1, color: inputMockupColor)
        .offset(x: 0, y: height * 0.33)
      square(size: squareSize, color: inputMockupColor)
        .offset(x: -width * 0.33, y: height * 0.19)
      square(size: squareSize, color: inputMockupColor)
        .offset(x: width * 0.33, y: height * 0.19)
      square(size: squareSize, color: correctAnswersMockupColor)
        .offset(x: width * 0.33, y: -height * 0.31)
      square(size: squareSize, color: inputMockupColor)
        .offset(x: -width * 0.33, y: -height * 0.31)
    }
  }

  // disabling linter because this will be refactored
  // swiftlint:disable:next function_body_length
  private func equationsMockup() -> some View {
    Group {
      Rectangle()
        .fill(equationRowColor)
        .frame(width: width * 0.4, height: width * 0.1)
        .offset(x: isDrifted ? -width * 0.15 : -width * 0.1, y: height * 0.04)

      Rectangle()
        .fill(Color.unanswered)
        .frame(width: width * 0.15, height: width * 0.1)
        .offset(x: isDrifted ? width * 0.17 : width * 0.22, y: height * 0.04)

      Rectangle()
        .fill(equationRowColor)
        .frame(width: width * 0.4, height: width * 0.1)
        .offset(x: isDrifted ? -width * 0.05 : -width * 0.1, y: -height * 0.03)

      Rectangle()
        .fill(Color.unanswered)
        .frame(width: width * 0.15, height: width * 0.1)
        .offset(x: isDrifted ? width * 0.27 : width * 0.22, y: -height * 0.03)

      Rectangle()
        .fill(equationRowColor)
        .frame(width: width * 0.4, height: width * 0.1)
        .offset(x: isDrifted ? -width * 0.15 : -width * 0.1, y: -height * 0.10)

      Rectangle()
        .fill(Color.currentAnswer)
        .frame(width: width * 0.15, height: width * 0.1)
        .offset(x: isDrifted ? width * 0.17 : width * 0.22, y: -height * 0.10)

      Rectangle()
        .fill(equationRowColor)
        .frame(width: width * 0.4, height: width * 0.1)
        .offset(x: isDrifted ? -width * 0.05 : -width * 0.1, y: -height * 0.17)

      Rectangle()
        .fill(Color.correctAnswer)
        .frame(width: width * 0.15, height: width * 0.1)
        .offset(x: isDrifted ? width * 0.27 : width * 0.22, y: -height * 0.17)

      Rectangle()
        .fill(equationRowColor)
        .frame(width: width * 0.4, height: width * 0.1)
        .offset(x: isDrifted ? -width * 0.15 :  -width * 0.1, y: -height * 0.24)

      Rectangle()
        .fill(Color.correctAnswer)
        .frame(width: width * 0.15, height: width * 0.1)
        .offset(x: isDrifted ? width * 0.17 : width * 0.22, y: -height * 0.24)
    }
  }
}

private struct IPhoneView: View {
  private var hardwareStrokeColor = Color.miniDeviceHardwareStroke
  let width: CGFloat
  let height: CGFloat
  var screenColor: Color

  init(width: CGFloat, height: CGFloat, screenColor: Color) {
    self.width = width
    self.height = height
    self.screenColor = screenColor
  }

  var body: some View {
    ZStack {
      // bazel
      RoundedRectangle(cornerRadius: width / 6.6, style: .continuous)
        .fill(Color.miniDeviceFrame)
      // screen
      Rectangle()
        .fill(screenColor)
        .frame(width: width * 0.83, height: height * 0.74)
      // home button
      Circle()
        .stroke(lineWidth: width / 100)
        .foregroundColor(hardwareStrokeColor)
        .frame(width: width * 0.15, height: width * 0.15)
        .offset(x: 0, y: height * 0.43)
      // camera
      Circle()
        .stroke(lineWidth: width / 200)
        .foregroundColor(hardwareStrokeColor)
        .frame(width: width * 0.045, height: width * 0.045)
        .offset(x: 0, y: -height * 0.45)
      // speaker
      RoundedRectangle(cornerRadius: width * 0.015, style: .continuous)
        .stroke(lineWidth: width / 200)
        .foregroundColor(hardwareStrokeColor)
        .frame(width: width * 0.16, height: height * 0.014)
        .offset(x: 0, y: -height * 0.405)
    }
    .frame(width: width, height: height)
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    Container()
      .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
      .previewDisplayName("iPhone 8")
  }
}
