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
    
    init() {
        AppLog("Launching...")
        #if DEBUG
        
        let args = extractArgs()
        
        AppLog("Launch Args: \(args)")
        
        // Determine if Unit Tests are running. The UI will not display.
        isUnitTest = args.keys.contains("UNIT_TEST")
        
        // Override the API URL (used in UI Testing to set up different testing scenarios)
        if let overrideApiUrl = args["OVERRIDE_API_URL"] {
            ITunesAPI.singleton.baseUrlString = overrideApiUrl
        }

        #endif
    }
    
    func extractArgs() -> [String: String] {
        var ret = [String: String]()
        for arg in ProcessInfo.processInfo.arguments {
            let tokens = arg.split(separator: "=")
            if let key = tokens.first, let value = tokens.last {
                ret[String(key)] = String(value)
            } else {
                ret[arg] = ""
            }
        }
        
        return ret
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
