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
    var albumSortOrder: AlbumSortOrder {get set}
}


@MainActor
final class AlbumsRepository: AlbumsRepositoryProtocol, ObservableObject {
    
    static let singleton = AlbumsRepository()
    
    @Published var albums = [Album]()
    var albumsPublished: Published<[Album]> {_albums}
    var albumsPublisher: Published<[Album]>.Publisher {$albums}
    
    var albumSortOrder = AlbumSortOrder.title {
        didSet {
            albums = sort(albums: albums)
        }
    }
    
    private let albumsRepositoryDataProvider: AlbumsRepositoryDataProviderProtocol
    
    init(
        albumsRepositoryDataProvider: AlbumsRepositoryDataProviderProtocol = AlbumsRepositoryDataProvider(.live)
    ) {
        AppLog()
        self.albumsRepositoryDataProvider = albumsRepositoryDataProvider
        fetchAlbums()
    }


    func fetchAlbums() {
        Task {
            guard let albums = await albumsRepositoryDataProvider.get().getSuccessOrLogError() else {
                return
            }
            
            self.albums = albums
            AppLog("albums: \(albums)")
        }
    }
    
    // Sadly the API doesn't support sorting, so we have to sort the objects ourselves
    func sort(albums: [Album]) -> [Album] {
        
        switch albumSortOrder {
            case .title:
                return albums.sorted { $0.name < $1.name }
            case .releaseDate:
                return albums.sorted { $0.releaseDate < $1.releaseDate }
        }
    }
}
