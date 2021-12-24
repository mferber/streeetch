import Foundation
import AVFoundation

class SoundPlayer {
  enum Sound {
    case countdown
    case start
    case stop

    var url: URL {
      switch self {
        case .countdown: return Bundle.main.url(forResource: "countdown", withExtension: "wav")!
        case .start: return Bundle.main.url(forResource: "startstop", withExtension: "wav")!
        case .stop: return Bundle.main.url(forResource: "startstop", withExtension: "wav")!
      }
    }
  }



  let audioSession = AVAudioSession.sharedInstance()
  let countdownSoundURL = Bundle.main.url(forResource: "countdown", withExtension: "wav")!
  let startSoundURL = Bundle.main.url(forResource: "startstop", withExtension: "wav")!
  let stopSoundURL = Bundle.main.url(forResource: "startstop", withExtension: "wav")!

  var player: AVAudioPlayer!
  var playerDelegate: AVAudioPlayerDelegate?

  init() {
    do {
      try audioSession.setCategory(AVAudioSession.Category.playback,
                                   mode: AVAudioSession.Mode.default,
                                   options: [.mixWithOthers, .duckOthers])
    } catch {
      print("Audio session initialization failed: \(error.localizedDescription)")
    }
  }

  func activateAudioSession() {
    do {
      try audioSession.setActive(true)
    } catch {
      print("Activating audio session failed: \(error.localizedDescription)")
    }
  }

  func deactivateAudioSession() {
    do {
      try audioSession.setActive(false)
    } catch {
      print("Deactivating audio session failed: \(error.localizedDescription)")
    }
  }

  func play(_ sound: Sound, then action: (() -> Void)? = nil) {
    do {
      player = try AVAudioPlayer(contentsOf: sound.url)
      playerDelegate = SoundPlayerDelegate { [weak self] in
        self?.player = nil
        if let action = action {
          action()
        }
      }
      player.delegate = playerDelegate

      player.play()
    } catch {
      print("Sound player failed: \(error.localizedDescription)")
    }
  }
}

class SoundPlayerDelegate: NSObject, AVAudioPlayerDelegate {
  let action: () -> Void

  init(action: @escaping () -> Void) {
    self.action = action
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    action()
  }
}
