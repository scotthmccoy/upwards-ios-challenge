//
//  AlbumTests.swift
//  upwards-ios-challengeTests
//
//  Created by Scott McCoy on 1/10/25.
//

import XCTest
@testable import upwards_ios_challenge
final class AlbumCellViewModelTests: XCTestCase {

    @MainActor func testIsNew() {
        var album = Album.stub
        album.releaseDate = Date(iso8601: "2025-01-01T00:00:00")!
        let today = Date(iso8601: "2025-01-25T00:00:00")!
        
        let sut = AlbumCellViewModel(album: album)
        XCTAssertTrue(sut.isNew(today: today))
    }
}
