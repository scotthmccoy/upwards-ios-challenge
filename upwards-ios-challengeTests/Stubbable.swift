//
//  Stubbable.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/10/25.
//


import Foundation
@testable import upwards_ios_challenge

public protocol Stubbable {
    static var stub: Self {get}
}


extension Album: Stubbable {
    public static var stub: Self {
        Album(
            id: "abc123",
            name: "Album Name",
            artistName: "Artist Name",
            releaseDate: Date(iso8601: "2025-01-01T00:00:00")!
        )
    }
}
