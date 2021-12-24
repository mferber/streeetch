//
//  StreeetchApp.swift
//  Streeetch
//
//  Created by Matthias Ferber on 12/23/21.
//

import SwiftUI

let numberOfReps = 3 //15
let secondsPerRep = 5 //15
let secondsToCountDown = 2 // 3

@main
struct StreeetchApp: App {
    var body: some Scene {
        WindowGroup {
          StretchView(context: StretchContext())
        }
    }
}

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

class StretchContext: ObservableObject {
  @Published var status = Status.unstarted
  @Published var side: Side? = nil
  @Published var rep = 1
  @Published var clock = secondsPerRep
  @Published var paused = false

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
    timer = .scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      if let timerExpires = self.timerExpires {
        let remaining = timerExpires.timeIntervalSince(Date())
        if remaining <= 0 {
          self.startRep()
        } else {
          self.clock = Int(ceil(remaining))
        }
      }
    }
    clock = secondsToCountDown
    status = .getReady
  }

  private func startRep() {
    timer?.invalidate()
    timerExpires = Date().addingTimeInterval(TimeInterval(secondsPerRep))
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
    clock = secondsPerRep
    status = .rep
  }

  func finishRep() {
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


