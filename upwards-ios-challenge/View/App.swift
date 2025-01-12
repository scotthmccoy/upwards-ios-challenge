//
//  AppDelegate.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/7/21.
//

import SwiftUI

@main
struct UpwardsChallengeApp: App {
    
    init() {
        AppLog("Launching...")
        
        // TODO: extract launch args to set API url
    }
    
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
