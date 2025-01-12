//
//  AlbumsRepository.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation


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
        guard let albums = await albumsRepositoryDataProvider.get().getSuccessOrLogError() else {
            return
        }
        
        self.albums = albums
        AppLog("albums: \(albums)")
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
