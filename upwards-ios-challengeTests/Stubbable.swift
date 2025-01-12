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
            releaseDate: Date(iso8601: "2025-01-01T00:00:00")!,
            genres: []
        )
    }
}

extension URL: Stubbable {
    public static var stub: Self {
        URL(string: "stub.com")!
    }
}

extension URLRequest: Stubbable {
    public static var stub: Self {
        URLRequest(url: URL.stub)
    }
}

extension HTTPURLResponse: Stubbable {
    public static var stub: Self {
        HTTPURLResponse(
            url: URL.stub,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )! as! Self
    }
}

extension Data: Stubbable {
    public static var stub: Self {
        "Foo".data(using: .utf8)!
    }
}
