//
//  StretchView.swift
//  Streeetch
//
//  Created by Matthias Ferber on 12/23/21.
//

import SwiftUI

struct StretchView: View {

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

  @ObservedObject var context: StretchContext

  var body: some View {
    VStack(spacing: 20) {
      mainButton()
      HStack {
        sideText(.left, active: .left == context.side)
        sideText(.right, active: .right == context.side)
      }
      clockDisplay()
      statusText()
    }
  }

  private func mainButton() -> some View {
    var text: String
    var color: Color

    switch context.status {
      case .unstarted:
        text = "Start"
        color = .green
      case .getReady, .rep:
        if context.paused {
          text = "Resume"
          color = .green
        } else {
          text = "Pause"
          color = .yellow
        }
      default:
        text = "..."
        color = .gray
    }

    return Button(action: { clickMainButton() }) {
      Text(text).fontWeight(.black).foregroundColor(.white).padding()
    }
    .background(color)
    .cornerRadius(20)
  }

  func clockDisplay() -> some View {
    var text: String
    switch context.status {
      case .unstarted: text = "—"
      case .getReady, .rep: text = String(context.clock)
      default: text = ""
    }
    let color: Color = context.status == .rep ? .black : Color(white: 0.8)
    return Text(text).font(.largeTitle).fontWeight(.black).foregroundColor(color)
  }

  func statusText() -> some View {
    var text: String
    switch context.status {
      case .unstarted: text = "Ready to start"
      case .getReady: text = "Get ready..."
      case .rep: text = "Rep \(context.rep) of \(numberOfReps)"
      default: text = ""
    }
    return Text(text)
  }

  func sideText(_ thisSide: Side, active: Bool) -> some View {
    let text = Text(String(describing: thisSide))
    if (active) {
      return text.fontWeight(.black)
    } else {
      return text.foregroundColor(.gray)
    }
  }

  func clickMainButton() {
    switch context.status {
      case .unstarted: context.start()
      case .getReady, .rep:
        if context.paused {
          context.resume()
        } else {
          context.pause()
        }
      default: break
    }
  }
}

struct StretchView_Previews: PreviewProvider {
  static let startingUp = StretchContext()
  static var getReady: StretchContext = {
    var context = StretchContext()
    context.status = .getReady
    context.side = .right
    context.rep = 4
    context.clock = 2
    return context
  }()
  static var rep: StretchContext = {
    var context = StretchContext()
    context.status = .rep
    context.side = .right
    context.rep = 4
    context.clock = 11
    return context
  }()
  static var previews: some View {
    StretchView(context: startingUp)
    StretchView(context: getReady)
    StretchView(context: rep)
  }
}
