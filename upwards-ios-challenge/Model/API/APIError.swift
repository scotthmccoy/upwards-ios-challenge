//
//  APIErrors.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

enum APIError: Error {
    case invalidUrl(String)
    case noResponse
    case decodingError(Error)
    case invalidDate(String)
}
