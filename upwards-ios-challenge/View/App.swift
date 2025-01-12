//
//  AppDelegate.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/7/21.
//

import SwiftUI

@main
struct UpwardsChallengeApp: App {
    
    var isUnitTest = false
    var overrideNetworkUrl: String? = nil
    
    init() {
        AppLog("Launching...")
        #if DEBUG
        
        AppLog("Launch Args: \(ProcessInfo.processInfo.arguments)")
        isUnitTest = ProcessInfo.processInfo.arguments.contains("UNIT_TEST")
        
        
        
        #endif
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
