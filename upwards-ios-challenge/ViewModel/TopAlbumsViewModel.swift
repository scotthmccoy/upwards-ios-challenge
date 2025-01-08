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
    @Published var sortOrders = AlbumSortOrder.allCases
    @Published var albumSortOrder = AlbumSortOrder.title
    
    
    private var albumsRepository: AlbumsRepositoryProtocol
    private var albumsSubscription: AnyCancellable?
    
    init(
        albumsRepository: AlbumsRepositoryProtocol = AlbumsRepository.singleton
    ) {
        self.albumsRepository = albumsRepository
        
        albumsSubscription = albumsRepository.albumsPublisher.sink { newValue in
            
            Task {
                await MainActor.run {
                    self.albums = newValue
                }
            }
        }
    }
    
    func menuTapped(albumSortOrder: AlbumSortOrder) {
        AppLog("albumSortOrder: \(albumSortOrder)")
        self.albumSortOrder = albumSortOrder
    }
}
