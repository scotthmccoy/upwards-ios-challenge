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
    case hardCoded
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
            case .hardCoded:
                let albums = [
                    Album(
                        id: "1787022393",
                        name: "DeBÍ TiRAR MáS FOToS",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/90/5e/7e/905e7ed5-a8fa-a8f3-cd06-0028fdf3afaa/199066342442.jpg/100x100bb.jpg"),
                        artistName: "Bad Bunny",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 757728000.0
                        )
                    ),
                    Album(
                        id: "1786672591",
                        name: "WHAM",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/a5/43/d2/a543d286-abf2-5cc5-5515-1feb4a56293d/24UM1IM32309.rgb.jpg/100x100bb.jpg"),
                        artistName: "Lil Baby",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 757555200.0
                        )
                    ),
                    Album(
                        id: "1781270319",
                        name: "GNX",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/50/c2/cc/50c2cc95-3658-9417-0d4b-831abde44ba1/24UM1IM28978.rgb.jpg/100x100bb.jpg"),
                        artistName: "Kendrick Lamar",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 753926400.0
                        )
                    ),
                    Album(
                        id: "1786643044",
                        name: "SOS Deluxe: LANA",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/97/bd/88/97bd8804-7d3e-e6c8-0532-ff22877b931c/196871766890.jpg/100x100bb.jpg"),
                        artistName: "SZA",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 756345600.0
                        )
                    ),
                    Album(
                        id: "1772364192",
                        name: "Wicked: The Soundtrack",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/3b/c3/80/3bc38021-d755-d689-43d2-775c6071b226/24UM1IM07582.rgb.jpg/100x100bb.jpg"),
                        artistName: "Wicked Movie Cast, Cynthia Erivo & Ariana Grande",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 753926400.0
                        )
                    ),
                    Album(
                        id: "1772368554",
                        name: "Last Lap",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/5a/37/da/5a37da14-dea1-6123-6553-4a24010657e8/196872534610.jpg/100x100bb.jpg"),
                        artistName: "Rod Wave",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 750297600.0
                        )
                    ),
                    Album(
                        id: "1776500452",
                        name: "CHROMAKOPIA",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/7d/bd/e9/7dbde97e-b97d-8cc3-0203-218b687408a9/196872555059.jpg/100x100bb.jpg"),
                        artistName: "Tyler, The Creator",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 751766400.0
                        )
                    ),
                    Album(
                        id: "1783609512",
                        name: "Dlow Curry",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/a9/77/36/a977361a-ff20-d994-55bd-b6c935d98f2a/196872707458.jpg/100x100bb.jpg"),
                        artistName: "Bossman Dlow",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 755740800.0
                        )
                    ),
                    Album(
                        id: "1750307020",
                        name: "Short n\' Sweet",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/f6/15/d0/f615d0ab-e0c4-575d-907e-1cc084642357/24UMGIM61704.rgb.jpg/100x100bb.jpg"),
                        artistName: "Sabrina Carpenter",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 746064000.0
                        )
                    ),
                    Album(
                        id: "1739659134",
                        name: "HIT ME HARD AND SOFT",
                        artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music211/v4/92/9f/69/929f69f1-9977-3a44-d674-11f70c852d1b/24UMGIM36186.rgb.jpg/100x100bb.jpg"),
                        artistName: "Billie Eilish",
                        releaseDate: Date(
                            timeIntervalSinceReferenceDate: 737596800.0
                        )
                    )
                ]
                
                return .success(albums)
        }
        

    }
    

}


