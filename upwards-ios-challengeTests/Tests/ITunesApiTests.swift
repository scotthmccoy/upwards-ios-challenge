//
//  ITunesApiTests.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/11/25.
//

import Foundation
import XCTest
@testable import upwards_ios_challenge

class ITunesApiTests: XCTestCase, @unchecked Sendable {
    
    // Test Config
    var requestDataResult: Result<Data, NetworkError> = .success(Data.stub)
    var codableHelperResult: Result<APIResponseDataObject, CodableHelperError> = .success(APIResponseDataObject.stub)

    // Expectations
    var expectationRequestData: XCTestExpectation?
    
    override func setUp() {
        requestDataResult = .success(Data.stub)
        codableHelperResult = .success(APIResponseDataObject.stub)
    }
    
    func testBasic() async {
        
        // Test configuration
        expectationRequestData = expectation(description: "expectationRequestData")
        
        // Interact with sut
        let sut = ITunesAPI(
            network: self,
            codableHelper: self
        )
        let actual = await sut.getTopAlbums()
        
        // Validation
        await fulfillment(of:[expectationRequestData!], timeout: 1.0)
        let expected: Result<[Album], ItunesAPIError> = .success([Album.stub])
        
        XCTAssertEqual(actual, expected)
    }
    
}

extension ITunesApiTests: NetworkProtocol {
    func requestData(urlRequest: URLRequest) async -> Result<Data, NetworkError> {
        expectationRequestData.fulfillOrFail(self)
        return requestDataResult
    }
}

extension ITunesApiTests: CodableHelperProtocol {
    func decode<T: Decodable>(
        type: T.Type,
        from data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    ) -> Result<T, CodableHelperError> {
        switch type {
            case is APIResponseDataObject.Type:
                return codableHelperResult as! Result<T, CodableHelperError>
            default:
                return .failure(.message("Testing Error"))
        }
    }
}
