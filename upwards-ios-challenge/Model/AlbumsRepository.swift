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
    
    init(
        albumsRepositoryDataProvider: AlbumsRepositoryDataProviderProtocol = AlbumsRepositoryDataProvider(.live)
    ) {
        AppLog()
        
        Task {
            guard let albums = await albumsRepositoryDataProvider.get().getSuccessOrLogError() else {
                return
            }
            
            self.albums = albums
        }
    }
}
