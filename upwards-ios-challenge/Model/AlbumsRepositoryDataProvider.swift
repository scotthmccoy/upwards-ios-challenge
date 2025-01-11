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
    case mainBundleTestData
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
                let ret = iTunesApiResult.map { apiResponseDataObject in
                    // Extract albums
                    apiResponseDataObject.albums
                }.mapError { error in
                    // Wrap APIError in AlbumsRepositoryDataProviderError
                    AlbumsRepositoryDataProviderError.apiError(error)
                }
                
                return ret
                
            // Useful for previews
            case .mainBundleTestData:
                
                guard let path = Bundle.main.path(forResource:"APIResponse.json", ofType: nil) else {
                    return .failure(.apiError(.noResponse))
                }
                
                let url = URL(fileURLWithPath: path)
                
                guard let data = try? Data(contentsOf: url) else {
                    return .failure(.apiError(.noResponse))
                }

                guard let apiResponseDataObject = CodableHelper().decode(
                    type: APIResponseDataObject.self,
                    from: data,
                    dateDecodingStrategy: .custom({(decoder) -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        if let date = dateFormatter.date(from: dateStr) {
                            return date
                        }
                        
                        throw APIError.invalidDate(dateStr)
                    })
                ).getSuccessOrLogError() else {
                    return .failure(.apiError(.noResponse))
                }
                
                let albums = apiResponseDataObject.albums

                return .success(albums)
        }
        

    }
    

}


