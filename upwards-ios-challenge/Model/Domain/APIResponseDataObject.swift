//
//  APIResponseDataObject.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/9/25.
//
import Foundation

// MARK: - AlbumFeed
struct APIResponseDataObject: Decodable {
    var feed: FeedDataObject?
    
    var albums: [Album] {
        guard let feed else {
            return []
        }
        return feed.albums
    }
}

struct FeedDataObject: Decodable {
    var results: [AlbumDataObject]?
    
    var albums: [Album] {
        guard let results else {
            return []
        }
        
        return results.compactMap {
            $0.album
        }
    }
}


// MARK: - Album
struct AlbumDataObject: Decodable {
    var artistName: String?
    var id: String?
    var name: String?
    var releaseDate: Date? // Note: In format "YYYY-MM-DD". Why did Apple not use iso8601??
    var kind: String?
    var artistId: String?
    var artistUrl: String?
    var contentAdvisoryRating: String?
    var artworkUrl100: String?
    var genres: [GenreDataObject]?
    var url: String?
    
    var album: Album? {
        
        guard let id, let name, let artworkUrl100, let artistName, let releaseDate else {
            return nil
        }
        
        // Extract genre names
        let genres = genres?.compactMap {
            $0.name
        } ?? []
        
        return Album(
            id: id,
            title: name,
            artworkUrl: URL(string: artworkUrl100),
            artistName: artistName,
            releaseDate: releaseDate,
            genres: genres
        )
    }
}

struct GenreDataObject: Decodable {
    var genreId: String?
    var name: String?
    var url: String?
}
