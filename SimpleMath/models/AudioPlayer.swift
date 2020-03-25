//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation
import AVFoundation

final class AudioPlayer {
  enum Sound: String {
    case greatSuccess = "great-success"
    case success
    case failure
  }
  
  private var player: AVAudioPlayer = AVAudioPlayer()
  
  func play(sound: Sound) {
    playSound(fromFile: sound.rawValue)
  }
  
  private func playSound(fromFile fileName: String) {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else { return }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
      player.play()
      
    } catch let error {
      print(error.localizedDescription)
    }
  }
}

