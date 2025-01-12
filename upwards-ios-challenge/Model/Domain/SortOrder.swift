//
//  SortOrder.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/8/25.
//

enum AlbumSortOrder: CaseIterable {
    case releaseDate
    case albumTitle
    case artistName
    case genre
}

extension AlbumSortOrder: CustomStringConvertible {
    var description: String {
        switch self {
            case .releaseDate: return "New"
            case .albumTitle: return "Album Title"
            case .artistName: return "Artist"
            case .genre: return "Genre"
        }
    }
}
