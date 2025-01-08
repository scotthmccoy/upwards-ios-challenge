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
    var visible = false
    
    
    private var albumsRepository: AlbumsRepositoryProtocol
    private var albumsSubscription: AnyCancellable?
    
    init(
        albumsRepository: AlbumsRepositoryProtocol = AlbumsRepository.singleton
    ) {
        self.albumsRepository = albumsRepository
        
        albumsSubscription = albumsRepository.albumsPublisher.sink { newValue in
            self.albums = newValue
        }
    }
    
}
