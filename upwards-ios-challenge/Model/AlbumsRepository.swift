//
//  AlbumsRepository.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation

// AlbumsRepository is the source of truth for the rest of the application and interface to the model layer for ViewModels.
// It is observable, provides Domain objects (Albums).

@MainActor
protocol AlbumsRepositoryProtocol {
    var albums: [Album] { get }
    var albumsPublisher: Published<[Album]>.Publisher { get }
    
    var errorMessage: String? { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }
    
    var albumSortOrder: AlbumSortOrder {get set}
    
    func fetchAlbums() async
}


@MainActor
final class AlbumsRepository: AlbumsRepositoryProtocol, ObservableObject {
    
    static let singleton = AlbumsRepository()
    
    @Published var albums = [Album]()
    var albumsPublisher: Published<[Album]>.Publisher {$albums}
    
    @Published var errorMessage: String? = nil
    var errorMessagePublisher: Published<String?>.Publisher {$errorMessage}
    
    var albumSortOrder = AlbumSortOrder.albumTitle {
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
        Task {
            await fetchAlbums()
        }
    }


    func fetchAlbums() async {
        AppLog()
        let result = await albumsRepositoryDataProvider.get()
        switch result {
            case .success(let albums):
                self.albums = sort(albums: albums)
            case .failure(let albumRepositoryDataProviderError):
                self.errorMessage = "\(albumRepositoryDataProviderError)"
        }
    }
    
    // Sadly the API doesn't support sorting, so we have to sort the objects ourselves
    func sort(albums: [Album]) -> [Album] {
        
        switch albumSortOrder {
            case .albumTitle:
                return albums.sorted { $0.title < $1.title }
            case .releaseDate:
                return albums.sorted { $0.releaseDate > $1.releaseDate }
            case .artistName:
                return albums.sorted { $0.artistName < $1.artistName }
            case .genre:
                
                // Lexicographic sorting via tuples - first genres, then resolve ties by name
                return albums.sorted {
                    ($0.genres.joined(), $0.title)
                    <
                    ($1.genres.joined(), $1.title)
                }
        }
    }
}
