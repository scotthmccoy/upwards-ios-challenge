//
//  ITunesAPI.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

enum ItunesAPIError: Error {
    case apiRequestError(APIRequestError)
    case networkError(NetworkError)
    case codableHelperError(CodableHelperError)
}

// The API sadly only takes a limit arg, not a sort-ordering one.
// https://rss.applemarketingtools.com/
final class ITunesAPI: Sendable {

    static let singleton = ITunesAPI()
    
    static let baseURL = "https://rss.applemarketingtools.com"
    
    private let network: NetworkProtocol
    private let codableHelper: CodableHelperProtocol
    private let dateFormatter = DateFormatter()
    
    init(
        network: NetworkProtocol = Network(),
        codableHelper: CodableHelperProtocol = CodableHelper()
    ) {
        self.network = network
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.codableHelper = codableHelper
    }
    
    // Default method. Creates an APIRequest from the baseUrl.
    func getTopAlbums(
        limit: Int = 100
    ) async -> Result<[Album], ItunesAPIError> {
        
        // Create an APIRequest
        let apiRequest = APIRequest(
            urlString: "\(Self.baseURL)/api/v2/us/music/most-played/\(limit)/albums.json"
        )
        
        // Convert to URLRequest
        let result = apiRequest.asURLRequest()
        guard case let .success(urlRequest) = apiRequest.asURLRequest() else {
            return .failure(.apiRequestError(result.error!))
        }
        
        // Use private method to get albums
        return await getTopAlbums(urlRequest: urlRequest)
    }
    
    // Alternative method. Uses any URL. Useful for loading from the Bundle.
    func getTopAlbums(
        limit: Int = 100,
        url: URL
    ) async -> Result<[Album], ItunesAPIError> {
        
        let urlRequest = URLRequest(url: url)
        
        // Use private method to get albums
        return await getTopAlbums(urlRequest: urlRequest)
    }
    

    private func getTopAlbums(
        limit: Int = 100,
        urlRequest: URLRequest
    ) async -> Result<[Album], ItunesAPIError> {
        
        return await network.requestData(
            urlRequest: urlRequest
        ).mapError {
            // Wrap NetworkError
            .networkError($0)
        }.flatMap {
            // Convert Data to Result<APIResponseDataObject, APIError>
            codableHelper.decode(
                type: APIResponseDataObject.self,
                from: $0,
                dateDecodingStrategy: dateDecodingStrategy()
            )
            // Wrap CodableHelperError
            .mapError {
                .codableHelperError($0)
            }
        }
        // Convert APIResponseDataObject to Domain Object
        .map {
            $0.albums
        }
    }
    
    
    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        .custom({(decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            if let date = self.dateFormatter.date(from: dateStr) {
                return date
            }
            
            throw CodableHelperError.message("Invalid date format: \(dateStr)")
        })
    }
}
