//
//  Network.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

protocol Networking {
    func requestObject<T: Decodable>(
        _ request: Request,
        completion: @escaping (Result<T, APIError>) -> ()
    )
    
    func requestData(
        _ request: Request,
        completion: @escaping (Result<Data, APIError>) -> ()
    )
}
