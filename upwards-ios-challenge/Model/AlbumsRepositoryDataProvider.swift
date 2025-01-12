//
//  AlbumsRepositoryDataProvider.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation

enum AlbumsRepositoryDataProviderError: Error, Equatable {
    case bundleError
    case itunesApiError(ItunesAPIError)
}

enum AlbumsRepositoryDataProviderSource {
    case live
    case mainBundleTestData
}

protocol AlbumsRepositoryDataProviderProtocol: Sendable {
    func get() async -> Result<[Album], AlbumsRepositoryDataProviderError>
}


final class AlbumsRepositoryDataProvider: AlbumsRepositoryDataProviderProtocol {

    let albumsRepositoryDataProviderSource: AlbumsRepositoryDataProviderSource
    let iTunesApi: ITunesAPIProtocol
    
    init(
        _ albumsRepositoryDataProviderSource: AlbumsRepositoryDataProviderSource,
        iTunesApi: ITunesAPIProtocol = ITunesAPI.singleton
    ) {
        self.albumsRepositoryDataProviderSource = albumsRepositoryDataProviderSource
        self.iTunesApi = iTunesApi
    }
    
    func get() async -> Result<[Album], AlbumsRepositoryDataProviderError> {
        
        
        switch albumsRepositoryDataProviderSource {
            case .live:

                let ret = await iTunesApi.getTopAlbums().mapError {
                    // Wrap ItunesApiError
                    AlbumsRepositoryDataProviderError.itunesApiError($0)
                }
                
                return ret
                
            // Useful for previews
            case .mainBundleTestData:
                
                guard let path = Bundle.main.path(forResource:"APIResponse.json", ofType: nil) else {
                    return .failure(.bundleError)
                }
                
                let url = URL(fileURLWithPath: path)
                
                let result = await iTunesApi.getTopAlbums(url: url).mapError {
                    // Wrap ItunesApiError
                    AlbumsRepositoryDataProviderError.itunesApiError($0)
                }.map {
                    // If successful, ruin the first image so that the default image shows
                    let badAlbum = Album(
                        id: "abc123",
                        name: "Bad Album",
                        artworkUrl: URL(string: "http://foo.com/bad.jpg"),
                        artistName: "Scott McCoy",
                        releaseDate: Date(iso8601: "2025-01-01T00:00:00")!,
                        genres: ["Hip-Hop"]
                    )
                    
                    var ret = $0
                    ret.insert(badAlbum, at:0)
                    return ret
                }
                
                return result
        }
        

    }
    

}


