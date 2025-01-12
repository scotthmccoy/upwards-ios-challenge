//
//  AlbumsRepositoryDataProvider.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import Foundation

enum AlbumsRepositoryDataProviderError: Error {
    case bundleError
    case itunesApiError(ItunesAPIError)
}

enum AlbumsRepositoryDataProviderSource {
    case live
    case mainBundleTestData
}

protocol AlbumsRepositoryDataProviderProtocol {
    func get() async -> Result<[Album], AlbumsRepositoryDataProviderError>
}


final class AlbumsRepositoryDataProvider: AlbumsRepositoryDataProviderProtocol {

    let albumsRepositoryDataProviderSource: AlbumsRepositoryDataProviderSource
    let iTunesApi: ITunesAPI
    
    init(
        _ albumsRepositoryDataProviderSource: AlbumsRepositoryDataProviderSource,
        iTunesApi: ITunesAPI = ITunesAPI.singleton
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
                
                let ret = await iTunesApi.getTopAlbums(url: url).mapError {
                    // Wrap ItunesApiError
                    AlbumsRepositoryDataProviderError.itunesApiError($0)
                }
                
                return ret
                
        }
        

    }
    

}


