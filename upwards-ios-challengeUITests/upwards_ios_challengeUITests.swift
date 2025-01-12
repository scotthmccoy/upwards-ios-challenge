//
//  upwards_ios_challengeUITests.swift
//  upwards-ios-challengeUITests
//
//  Created by Alex Livenson on 11/3/23.
//

import XCTest

final class upwards_ios_challengeUITests: XCTestCase {

    func test() {
        //Set some inputs
        let app = XCUIApplication()
        app.launchArguments = ["FOO"]
        app.launch()
    }
}
