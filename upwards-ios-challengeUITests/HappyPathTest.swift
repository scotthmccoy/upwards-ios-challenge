//
//  HappyPathTest.swift
//  upwards-ios-challengeUITests
//
//  Created by Scott McCoy on 1/12/25.
//

import Foundation
import XCTest
import Scootys_UI_Testing

final class HappyPathTest: XCTestCase {
    
    func test() {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
        
        // Wait for the loading animation to clear
        app.staticTexts["Loading..."].assertNotExists()

        // Wait for cells to load
        // Find all elements that have the accessibility id "AlbumViewCell"
        WaitFor.tryThrows {
            guard app.debugDescriptionProxies.count(where: {
                $0.identifier == "AlbumViewCell"
            }) > 3 else {
                throw TestingError("Not enough cells found")
            }
        }
        
        // Sort By New. Use a placeholder to force a tap on the center of the sort button
        let btnSort = app.buttons["btnSort"]
        app.tap(placeholder: Placeholder(btnSort))
        app.buttons.tap(label: "New")
        
        // Expect several New Tags
        WaitFor.tryThrows {
            guard app.debugDescriptionProxies.count(where: {
                $0.identifier == "NewTag"
            }) > 3 else {
                throw TestingError("Not enough NewTags found")
            }
        }
    }
}
