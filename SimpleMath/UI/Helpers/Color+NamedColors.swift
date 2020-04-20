//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info


import SwiftUI

extension Color {
  static let background = Color(#colorLiteral(red: 0.5803921569, green: 0.1294117647, blue: 0.5725490196, alpha: 1))
  static let primaryText = Color.white
  static let currentAnswer = Color(#colorLiteral(red: 0.2431372549, green: 0.4117647059, blue: 1, alpha: 1))
  static let correctAnswer = Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
  static let incorrectAnswer = Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
  static let unanswered = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
  static let discard = Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
  static let confirm = Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
  static let progressIncomplete = Color(#colorLiteral(red: 0.3870187126, green: 0.08371740527, blue: 0.3813446013, alpha: 1))
  static let progressComplete = primaryText
  static let playPause = primaryText
  static let yellowStar = confirm
  static let miniDeviceFrame = Color.black
  static let miniDeviceHardwareStroke = unanswered
  static let miniDeviceInputMockupGray = Color(#colorLiteral(red: 0.4346842596, green: 0.4346842596, blue: 0.4346842596, alpha: 1))
  static let miniDeviceInputMockupGreen = Color(#colorLiteral(red: 0.2297284843, green: 0.3980296213, blue: 0.1192763537, alpha: 1))
  static let settingPanelBackgroundBase = Color.black
  static let settingCellBackgroundBase = Color.white
  static let settingTextFieldBorder = Color(#colorLiteral(red: 0.2286085633, green: 0.2460217858, blue: 0.2703869619, alpha: 1))
  static let settingTextFieldBorderInvalid = Color(#colorLiteral(red: 0.6098763117, green: 0.01243970383, blue: 0.2637666402, alpha: 1))
  static let settingEquationEnabled = primaryText
  static let settingEquationDisabled = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
  static let settingStepperBackground = Color(#colorLiteral(red: 0.2286085633, green: 0.2460217858, blue: 0.2703869619, alpha: 1))
}

//this is temporary, should move all colors to assets soon
extension UIColor {
  static let primaryText = UIColor.white
}
