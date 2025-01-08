//
//  AlbumsRepository.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation

// AlbumsRepository is Observable, unlike AlbumsRepositoryActor (the source of truth).
// It monitors AlbumsRepositoryDataProvider for changes and updates AlbumsRepositoryActor

@MainActor
protocol AlbumsRepositoryProtocol {
    var albums: [Album] { get }
    var albumsPublished: Published<[Album]> { get }
    var albumsPublisher: Published<[Album]>.Publisher { get }
}


@MainActor
final class AlbumsRepository: AlbumsRepositoryProtocol, ObservableObject {
    
    static let singleton = AlbumsRepository()
    
    @Published var albums = [Album]()
    var albumsPublished: Published<[Album]> {_albums}
    var albumsPublisher: Published<[Album]>.Publisher {$albums}
    
    init() {
        albums = [
            Album(id: "abc123", name: "My Album 1", artistName: "ArtistName", releaseDate: Date()),
            Album(id: "abc123", name: "My Album 2", artistName: "ArtistName", releaseDate: Date()),
            Album(id: "abc123", name: "My Album 3", artistName: "ArtistName", releaseDate: Date()),
            Album(id: "abc123", name: "My Album 4", artistName: "ArtistName", releaseDate: Date())
        ]
    }
}
