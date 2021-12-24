import Foundation
import AVFoundation

class SoundPlayer {
  let audioSession = AVAudioSession.sharedInstance()
  let countdownSoundURL = Bundle.main.url(forResource: "countdown", withExtension: "wav")!
  let startSoundURL = Bundle.main.url(forResource: "startstop", withExtension: "wav")!
  let stopSoundURL = Bundle.main.url(forResource: "startstop", withExtension: "wav")!

  var player: AVAudioPlayer!
  let delegate: AVAudioPlayerDelegate!

  init() {
    do {
      try audioSession.setCategory(AVAudioSession.Category.playback,
                                   mode: AVAudioSession.Mode.default,
                                   options: [.mixWithOthers, .duckOthers])
    } catch {
      print("Audio session initialization failed: \(error.localizedDescription)")
    }
    delegate = SoundPlayerDelegate(session: audioSession)
  }

  func playCountdownSound() { play(url: countdownSoundURL) }
  func playStartSound() { play(url: startSoundURL) }
  func playStopSound() { play(url: startSoundURL) }

  private func play(url: URL) {
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player.delegate = delegate
      try audioSession.setActive(true)
      player.play()
    } catch {
      print("Sound player failed: \(error.localizedDescription)")
    }
  }
}

class SoundPlayerDelegate: NSObject, AVAudioPlayerDelegate {
  let audioSession: AVAudioSession

  init(session: AVAudioSession) {
    self.audioSession = session
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    do {
      try audioSession.setActive(false)
    } catch {
      print("Audio session deactivation failed: \(error.localizedDescription)")
    }
  }
}
