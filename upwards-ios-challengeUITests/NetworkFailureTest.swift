//
//  upwards_ios_challengeUITests.swift
//  upwards-ios-challengeUITests
//
//  Created by Alex Livenson on 11/3/23.
//

import XCTest

import Scootys_UI_Testing

final class NetworkFailureTest: XCTestCase {

    func test() {
        let app = XCUIApplication()
        
        // Override the API URL to one that will cause an ATS failure
        app.launchArguments = ["OVERRIDE_API_URL=http://bad.com"]
        app.launch()
        
        // Expect that the UI will show an error message about App Transport Security
        app.buttons.tap(label: "Try Again")
        app.staticTexts.waitForContains(text: "App Transport Security")
    }
}
