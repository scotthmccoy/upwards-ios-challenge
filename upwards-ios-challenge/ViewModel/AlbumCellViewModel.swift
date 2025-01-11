//
//  AlbumCellViewModel.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/10/25.
//

import Foundation
import Combine

@MainActor
class AlbumCellViewModel: ObservableObject {
    
    let album: Album
    
    func isNew(
        today: Date = Date(),
        days: Int = 30
    ) -> Bool {
        album.releaseDate.inTheLast(days: days, today: today)
    }
    
    var genres: String {
        album.genres
        // Remove the somewhat useless genre of "Music"
        .filter {
            $0 != "Music"
        }
        .prefix(2)
        .joined(separator: ", ")
    }
    
    init(album: Album) {
        self.album = album
    }
    
}
