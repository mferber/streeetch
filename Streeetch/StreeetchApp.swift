//
//  StreeetchApp.swift
//  Streeetch
//
//  Created by Matthias Ferber on 12/23/21.
//

import SwiftUI

let numberOfReps = 15
let secondsPerRep = 15
let secondsToCountDown = 3

@main
struct StreeetchApp: App {
  let context = StretchContext()

  var body: some Scene {
    WindowGroup {
      StretchView(context: context)
    }
  }
}
