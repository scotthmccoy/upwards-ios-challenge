//
//  Network.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl(String)
    case invalidRequest(APIRequestProtocol)
    case dataTaskError(Error)
    case invalidResponse
    case badStatusCode(Int)
}


protocol NetworkProtocol {
    func requestData(
        urlRequest: URLRequest
    ) async -> Result<Data, NetworkError>
}

final class Network: NetworkProtocol {
    private let sessionConfig: URLSessionConfiguration
    private let decoder = JSONDecoder()
    private lazy var session: URLSession = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    
    init(
        sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
    ) {
        self.sessionConfig = sessionConfig
    }
    
    func requestData(
        urlRequest: URLRequest
    ) async -> Result<Data, NetworkError> {
        
        AppLog("urlRequest: \(urlRequest)")

        // Get Data
        let urlSessionResult = await Result.asyncCatching {
            try await session.data(for: urlRequest)
        }

        guard case let .success((data, urlResponse)) = urlSessionResult else {
            return .failure(.dataTaskError(urlSessionResult.error!))
        }

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return .success(data)
        }
        
        // Handle HTTPURLResponse
        guard (200..<300) ~= httpResponse.statusCode else {
            return .failure(.badStatusCode(httpResponse.statusCode))
        }
        
        return .success(data)
    }
}
