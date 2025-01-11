//
//  AppDelegate.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/7/21.
//

import SwiftUI

@main
struct UpwardsChallengeApp: App {
    
    var isUnitTest : Bool {
        return ProcessInfo.processInfo.arguments.contains("UNIT_TEST")
    }

    var body: some Scene {
        WindowGroup {
            if (!isUnitTest) {
                NavigationStack {
                    TopAlbumsView()
                        .preferredColorScheme(.dark)
                }
            }
        }
    }
}
