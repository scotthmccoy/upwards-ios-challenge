//
//  AlbumsRepositoryDataProvider.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation

enum AlbumsRepositoryDataProviderError: Error {
    case apiError(APIError)
}

enum AlbumsRepositoryDataProviderSource {
    case live
    case hardCoded
}

protocol AlbumsRepositoryDataProviderProtocol {
    func get() async -> Result<[Album], AlbumsRepositoryDataProviderError>
}


final class AlbumsRepositoryDataProvider: AlbumsRepositoryDataProviderProtocol {

    let albumsRepositoryDataProviderSource: AlbumsRepositoryDataProviderSource
    
    init(_ albumsRepositoryDataProviderSource: AlbumsRepositoryDataProviderSource) {
        self.albumsRepositoryDataProviderSource = albumsRepositoryDataProviderSource
    }
    
    func get() async -> Result<[Album], AlbumsRepositoryDataProviderError> {
        
        
        switch albumsRepositoryDataProviderSource {
            case .live:
                
                let network = Network(sessionConfig: URLSessionConfiguration.default)
                let iTunesApi = ITunesAPI(network: network)
                
                let iTunesApiResult = await withCheckedContinuation { continuation in
                    iTunesApi.getTopAlbums { result in
                        continuation.resume(returning: result)
                    }
                }
                
                // Grab feed.results and wrap APIError in AlbumsRepositoryDataProviderError
                let ret = iTunesApiResult.map { albumFeed in
                    albumFeed.feed.results
                }.mapError { error in
                    AlbumsRepositoryDataProviderError.apiError(error)
                }
                
                return ret
                
            case .hardCoded:
                return .success([
                    Album(id: "abc123", name: "My Album 1", artistName: "ArtistName", releaseDate: Date()),
                    Album(id: "abc123", name: "My Album 2", artistName: "ArtistName", releaseDate: Date()),
                    Album(id: "abc123", name: "My Album 3", artistName: "ArtistName", releaseDate: Date()),
                    Album(id: "abc123", name: "My Album 4", artistName: "ArtistName", releaseDate: Date())
                ])
        }
        

    }
    

}


