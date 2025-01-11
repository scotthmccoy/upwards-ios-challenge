//
//  upwards_ios_challengeTests.swift
//  upwards-ios-challengeTests
//
//  Created by Alex Livenson on 11/3/23.
//

import XCTest
import Scootys_Unit_Testing
@testable import upwards_ios_challenge

final class AlbumsRepositoryDataProviderTests: XCTestCase {

    func test() async {
        let sut = AlbumsRepositoryDataProvider(.live)
        let result = await sut.get()
        let albums = try! result.get()
        print("swiftInitStatement: \(albums.swiftInitStatement!)")
    }
}
