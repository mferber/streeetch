import Foundation

class StretchContext: ObservableObject {
  enum Status {
    case unstarted
    case getReady
    case rep
    case finished
  }

  enum Side: CustomStringConvertible {
    case left
    case right
    var description: String {
      switch self {
        case .left: return "Left"
        case .right: return "Right"
      }
    }
  }

  @Published var status = Status.unstarted
  @Published var side: Side? = nil
  @Published var rep = 1
  @Published var clock = secondsPerRep
  @Published var paused = false

  private let soundPlayer = SoundPlayer()
  private var timer: Timer?
  private var timerExpires: Date?

  func start() {
    side = .left
    rep = 1
    clock = 15
    startCountdown()
  }

  private func startCountdown() {
    timer?.invalidate()
    timerExpires = Date().addingTimeInterval(TimeInterval(secondsToCountDown))
    clock = secondsToCountDown
    status = .getReady

    soundPlayer.activateAudioSession()
    soundPlayer.play(.countdown)

    timer = .scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      if let timerExpires = self.timerExpires {
        let remaining = timerExpires.timeIntervalSince(Date())
        if remaining <= 0 {
          self.startRep()
        } else {
          let newClock = Int(ceil(remaining))
          if self.clock != newClock {
            self.soundPlayer.play(.countdown)
            self.clock = newClock
          }
        }
      }
    }
  }

  private func startRep() {
    timer?.invalidate()
    timerExpires = Date().addingTimeInterval(TimeInterval(secondsPerRep))
    clock = secondsPerRep
    status = .rep

    soundPlayer.activateAudioSession()
    soundPlayer.play(.start, then: { [weak soundPlayer] in
      soundPlayer?.deactivateAudioSession()
    })

    timer = .scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      if let timerExpires = self.timerExpires {
        let remaining = timerExpires.timeIntervalSince(Date())
        if remaining <= 0 {
          self.finishRep()
        } else {
          self.clock = Int(ceil(remaining))
        }
      }
    }
  }

  func finishRep() {
    soundPlayer.play(.stop, then: { [weak soundPlayer] in
      soundPlayer?.deactivateAudioSession()
    })

    if side == .left {
      side = .right
      startCountdown()
    } else if rep < numberOfReps {
      rep += 1
      side = .left
      startCountdown()
    } else {
      status = .finished
      timerExpires = nil
      timer?.invalidate()
      timer = nil
    }
  }

  func pause() {
    paused = true
  }

  func resume() {
    paused = false
  }
}
