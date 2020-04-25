//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

import Foundation
import AVFoundation

final class AudioPlayer: AudioEngine {
  private var playerCache: [Sound: AVAudioPlayer] = [:]

  init() {
    cacheSounds()
  }

  private func load(sound: Sound) -> AVAudioPlayer? {
    guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "m4a") else { return nil }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      return try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)

    } catch {
      print("error loading sound \(sound) : \(error.localizedDescription)")
      return nil
    }
  }

  private func cacheSounds() {
    DispatchQueue.global().async { [weak self] in
      for sound in Sound.allCases {
        guard let player = self?.load(sound: sound) else { continue }
        DispatchQueue.main.async {
          self?.playerCache[sound] = player
        }
      }
    }
  }

  func play(sound: Sound) {
    if let player = playerCache[sound] {
      player.pause()
      player.currentTime = 0
      player.play()
    }
  }
}
