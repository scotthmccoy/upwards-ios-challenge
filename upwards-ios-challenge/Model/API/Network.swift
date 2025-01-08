//
//  Network.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation
import os.log



final class Network: NSObject, Networking, URLSessionDelegate {
    
    private let sessionConfig: URLSessionConfiguration
    private let decoder = JSONDecoder()
    private lazy var session: URLSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    
    init(sessionConfig: URLSessionConfiguration) {
        self.sessionConfig = sessionConfig
        super.init()
        configureDecoder()
    }
    
    func requestObject<T: Decodable>(_ request: Request, completion: @escaping (Result<T, APIError>) -> ()) {
        requestData(request) { res in
            completion(
                res.flatMap { data in
                    Result {
                        try self.decoder.decode(T.self, from: data)
                    }.mapError {
                        APIError.decodingError($0)
                    }
                }
            )
        }
    }
    
    func requestData(
        _ request: Request,
        completion: @escaping (Result<Data, APIError>) -> ()
    ) {
        
        guard let urlRequest = request.asURLRequest().getSuccessOrLogError() else {
            return
        }
        
        AppLog("urlRequest: \(urlRequest)")
        
        let task = session.dataTask(
            with: urlRequest
        ) { (data, res, err) in
            guard
                let httpResponse = res as? HTTPURLResponse,
                let d = data,
                (200..<300) ~= httpResponse.statusCode
            else {
                completion(.failure(APIError.noResponse))
                return
            }
            
            completion(.success(d))
        }
        task.resume()
    }
    
    // TODO: This could probably be folded into Codable's existing date formatting
    private func configureDecoder() {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            throw APIError.invalidDate(dateStr)
        })
    }
}
