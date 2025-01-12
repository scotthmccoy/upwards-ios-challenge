//
//  upwards_ios_challengeTests.swift
//  upwards-ios-challengeTests
//
//  Created by Alex Livenson on 11/3/23.
//

import XCTest
import Scootys_Unit_Testing
@testable import upwards_ios_challenge

final class AlbumsRepositoryDataProviderTests: XCTestCase, @unchecked Sendable {

    func testLive() async {
        // Configure test
        let sut = AlbumsRepositoryDataProvider(
            .live,
            iTunesApi: self
        )
        
        // Interact with sut
        let actual = await sut.get()
        
        // Validate
        let expected: Result<[Album], AlbumsRepositoryDataProviderError> = .success([.stub])
        XCTAssertEqual(actual, expected)
    }
    
    func testMainBundleTestData() async {
        // Configure test
        let sut = AlbumsRepositoryDataProvider(
            .mainBundleTestData,
            iTunesApi: self
        )
        
        // Interact with sut
        let actual = await sut.get()
        
        // Validate
        let albums = [
            Album(
                id: "abc123",
                title: "Bad Album",
                artworkUrl: URL(string: "http://foo.com/bad.jpg"),
                artistName: "Scott McCoy 🤘🏻",
                releaseDate: Date(iso8601: "2025-01-01T00:00:00")!,
                genres: [
                    "Hip-Hop"
                ]
            ),
            Album.stub
        ]
        let expected: Result<[Album], AlbumsRepositoryDataProviderError> = .success(albums)
        
        XCTAssertEqual(actual, expected)
    }

}

extension AlbumsRepositoryDataProviderTests: ITunesAPIProtocol {
    func getTopAlbums(url: URL, limit: Int) async -> Result<[Album], ItunesAPIError> {
        return .success([Album.stub])
    }
    
    func getTopAlbums(limit: Int) async -> Result<[Album], ItunesAPIError> {
        return .success([Album.stub])
    }
}
