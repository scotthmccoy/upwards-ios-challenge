//
//  DateExtensionTests.swift
//  upwards-ios-challengeTests
//
//  Created by Scott McCoy on 1/10/25.
//

import Foundation

import XCTest
@testable import upwards_ios_challenge

final class DateExtensionTests: XCTestCase {
    
    func testHappyPath() {
        let sut = Date(iso8601: "2025-01-01T00:00:00")!
        let today = Date(iso8601: "2025-01-25T00:00:00")!
        XCTAssertTrue(sut.inTheLast(days: 30, today: today))
    }

    func testFail() {
        let sut = Date(iso8601: "2025-01-01T00:00:00")!
        let today = Date(iso8601: "2025-01-25T00:00:00")!
        XCTAssertFalse(sut.inTheLast(days: 1, today: today))
    }

    func testNegative() {
        let sut = Date(iso8601: "2025-01-01T00:00:00")!
        let today = Date(iso8601: "2025-01-25T00:00:00")!
        XCTAssertFalse(sut.inTheLast(days: -30, today: today))
    }

}
