//
//  StreeetchApp.swift
//  Streeetch
//
//  Created by Matthias Ferber on 12/23/21.
//

import SwiftUI

#if SHORTER
let numberOfReps = 3
let secondsPerRep = 5
let secondsToCountDown = 3
#else
let numberOfReps = 15
let secondsPerRep = 15
let secondsToCountDown = 8
#endif

@main
struct StreeetchApp: App {
  let context = StretchContext()

  var body: some Scene {
    WindowGroup {
      StretchView(context: context)
    }
  }
}
