//
//  Album.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

// MARK: - Album
struct Album {
    var id: String
    var name: String
    var artworkUrl: URL?
    var artistName: String
    var releaseDate: Date
    var genres: [String]
    
    func isNew(
        today: Date = Date(),
        days: Int = 30
    ) -> Bool {
        releaseDate.inTheLast(days: days, today: today)
    }
}

// Album support Hashable for easy display in SwiftUI and Encodable for .swiftInitStatement
extension Album: Hashable, Encodable {}
