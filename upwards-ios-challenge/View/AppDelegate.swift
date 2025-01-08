//
//  AppDelegate.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/7/21.
//

import SwiftUI

@main
struct UpwardsChallengeApp: App {
    

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TopAlbumsView()
            }
        }
    }
}
