//
//  ITunesAPI.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import Foundation

// The API sadly only takes a limit arg, not a sort-ordering one.
// https://rss.applemarketingtools.com/
final class ITunesAPI {

    let baseURL = "https://rss.applemarketingtools.com"
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func getTopAlbums(
        limit: Int = 10,
        completion: @escaping (Result<AlbumFeed, APIError>) -> ()
    )  {
        let request = APIRequest(url: "\(baseURL)/api/v2/us/music/most-played/\(limit)/albums.json")
        
        network.requestObject(
            request,
            completion: completion
        )
    }
}
