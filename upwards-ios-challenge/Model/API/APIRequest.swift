//
//  APIRequest.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

protocol APIRequestProtocol: CustomStringConvertible {
    func asURLRequest() -> Result<URLRequest, APIRequestError>
}

enum APIRequestError: Error {
    case invalidUrl(String)
}

struct APIRequest: APIRequestProtocol {

    var urlString: String
    var method: HTTPMethod = .get
    var headers: [String: String]? = nil
    var body: Data? = nil

    func asURLRequest() -> Result<URLRequest, APIRequestError> {
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidUrl(urlString))
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body

        return .success(request)
    }
    
    var description: String {
        "\(method) - \(urlString)"
    }
}
