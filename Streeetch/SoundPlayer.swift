import Foundation
import AVFoundation

class SoundPlayer {
  let audioSession = AVAudioSession.sharedInstance()
  let countdownSoundURL = Bundle.main.url(forResource: "countdown", withExtension: "wav")!
  let startSoundURL = Bundle.main.url(forResource: "startstop", withExtension: "wav")!
  let stopSoundURL = Bundle.main.url(forResource: "startstop", withExtension: "wav")!

  var player: AVAudioPlayer!

  func playCountdownSound() { play(url: countdownSoundURL) }
  func playStartSound() { play(url: startSoundURL) }
  func playStopSound() { play(url: startSoundURL) }

  private func play(url: URL) {
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player.play()
    } catch {
      print("Sound player failed: \(error.localizedDescription)")
    }
  }
}
