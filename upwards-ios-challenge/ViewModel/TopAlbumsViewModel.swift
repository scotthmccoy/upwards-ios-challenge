//
//  TopAlbumsViewModel.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation
import Combine

@MainActor
class TopAlbumsViewModel: ObservableObject {
    
    @Published var albums: [Album] = []
    @Published var albumSortOrder = AlbumSortOrder.albumTitle
    @Published var searchString = "" {
        didSet {
            albums = applySearch(albums: albumsRepository.albums)
        }
    }
    
    private var albumsRepository: AlbumsRepositoryProtocol
    private var albumsSubscription: AnyCancellable?
    
    init(
        albumsRepository: AlbumsRepositoryProtocol = AlbumsRepository.singleton
    ) {
        self.albumsRepository = albumsRepository
        
        // Listen for updates from repository
        albumsSubscription = albumsRepository.albumsPublisher.sink { newValue in
            Task {
                await MainActor.run {
                    self.albums = self.applySearch(albums: newValue)
                }
            }
        }
    }
    
    func menuTapped(albumSortOrder: AlbumSortOrder) {
        AppLog("albumSortOrder: \(albumSortOrder)")
        self.albumSortOrder = albumSortOrder

        albumsRepository.albumSortOrder = albumSortOrder
    }
    
    func applySearch(albums: [Album]) -> [Album] {
        guard searchString != "" else {
            return albums
        }
        
        return albums.filter {
            // TODO: This is a lot of string manipulation. Maybe add a searchfield to Album that contains
            // a lower cased version of all these fields concatenated together.
            $0.title.lowercased().contains(searchString.lowercased()) ||
            $0.artistName.lowercased().contains(searchString.lowercased()) ||
            $0.genres.contains {
                $0.lowercased().contains(searchString.lowercased())
            }
        }
    }
}
