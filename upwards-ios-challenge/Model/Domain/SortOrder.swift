//
//  SortOrder.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/8/25.
//

enum AlbumSortOrder: CaseIterable {
    case title
    case releaseDate
}

extension AlbumSortOrder: CustomStringConvertible {
    var description: String {
        switch self {
            case .title: return "Title"
            case .releaseDate: return "Release Date"
        }
    }
}
