//  SimpleMath
//  Copyright (c) Filip Lazov 2020
//  MIT license - see LICENSE file for more info

final class AudioEngineMock: AudioEngine {
  var playedSounds: [Sound] = []
  
  func play(sound: Sound) {
    playedSounds.append(sound)
  }
}
