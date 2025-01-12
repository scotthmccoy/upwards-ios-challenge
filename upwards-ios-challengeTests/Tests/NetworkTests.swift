//
//  NetworkTests.swift
//  upwards-ios-challengeTests
//
//  Created by Scott McCoy on 1/11/25.
//

import Foundation
import XCTest
@testable import upwards_ios_challenge
class NetworkTests: XCTestCase {
    
    // Test Config
    var errorToThrow: Error?
    var tupleToReturn = (Data(), URLResponse())
    
    // Expectations
    var expectationDataForRequest: XCTestExpectation?
    
    override func setUp() {
        errorToThrow = nil
        tupleToReturn = (
            Data.stub,
            URLResponse()
        )

        expectationDataForRequest = expectation(description: "expectationDataForRequest")
    }
    
    func testBasic() async {
        // Configure test
        let sut = Network(session: self)
        
        // Interact with sut
        let actual = await sut.requestData(urlRequest: URLRequest.stub)
        
        // Validation
        await fulfillment(of:[expectationDataForRequest!])
        let expected: Result<Data, NetworkError> = .success(tupleToReturn.0)
        XCTAssertEqual(actual, expected)
    }
    
    
    func testDataTaskThrows() async {
        // Configure test
        let sut = Network(session: self)
        errorToThrow = StubError.stub
        
        // Interact with sut
        let actual = await sut.requestData(urlRequest: URLRequest.stub)
        
        // Validation
        await fulfillment(of:[expectationDataForRequest!])
        let expected: Result<Data, NetworkError> = .failure(.dataTaskError("\(StubError.stub)"))
        XCTAssertEqual(actual, expected)
    }
    
    func testHttpUrlResponse() async {
        
        // Configure test
        let sut = Network(session: self)
        tupleToReturn = (Data(), HTTPURLResponse.stub)
        
        // Interact with sut
        let actual = await sut.requestData(urlRequest: URLRequest.stub)
        
        // Validation
        await fulfillment(of:[expectationDataForRequest!])
        let expected: Result<Data, NetworkError> = .success(tupleToReturn.0)
        XCTAssertEqual(actual, expected)
    }
    
    func testHttpUrlResponseBadStatusCode199() async {
        
        // Configure test
        let sut = Network(session: self)
        let httpUrlResponse = HTTPURLResponse(
            url: URL.stub,
            statusCode: 199,
            httpVersion: nil,
            headerFields: nil
        )!
        tupleToReturn = (Data(), httpUrlResponse)
        
        // Interact with sut
        let actual = await sut.requestData(urlRequest: URLRequest.stub)
        
        // Validation
        await fulfillment(of:[expectationDataForRequest!])
        let expected: Result<Data, NetworkError> = .failure(.badStatusCode(199))
        XCTAssertEqual(actual, expected)
    }
    
    func testHttpUrlResponseBadStatusCode300() async {
        
        // Configure test
        let sut = Network(session: self)
        let httpUrlResponse = HTTPURLResponse(
            url: URL.stub,
            statusCode: 300,
            httpVersion: nil,
            headerFields: nil
        )!
        tupleToReturn = (Data(), httpUrlResponse)
        
        // Interact with sut
        let actual = await sut.requestData(urlRequest: URLRequest.stub)
        
        // Validation
        await fulfillment(of:[expectationDataForRequest!])
        let expected: Result<Data, NetworkError> = .failure(.badStatusCode(300))
        XCTAssertEqual(actual, expected)
    }
    
}

extension NetworkTests: URLSessionProtocol {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse) {
        expectationDataForRequest.fulfillOrFail(self)
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        return tupleToReturn
    }
}
