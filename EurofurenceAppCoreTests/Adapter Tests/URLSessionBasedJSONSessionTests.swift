//
//  URLSessionBasedJSONSessionTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class JournallingURLRequestLogger {

    struct ExpectedRequest: Hashable {
        var url: String
        var assertion: ((URLRequest) -> Bool)?

        var hashValue: Int {
            return url.hashValue
        }

        static func ==(lhs: ExpectedRequest, rhs: ExpectedRequest) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }

        func expected(_ request: URLRequest) -> Bool {
            guard let actualURL = request.url else { return false }
            var satisfied = actualURL.absoluteString == url

            if let assertion = assertion, satisfied {
                satisfied = assertion(request)
            }

            return satisfied
        }
    }

    static let shared = JournallingURLRequestLogger()
    private var expectations = [ExpectedRequest : XCTestExpectation]()
    private var stubbedResponses = [String : Data]()
    private var stubbedErrors = [String : Error]()

    func setUp() {
        URLProtocol.registerClass(TestURLProtocol.self)
        expectations.removeAll()
    }

    func record(_ request: URLRequest) {
        var requestsToRemove = [ExpectedRequest]()
        for (expectedRequest, expectation) in expectations {
            if expectedRequest.expected(request) {
                expectation.fulfill()
                requestsToRemove.append(expectedRequest)
            }
        }

        for request in requestsToRemove {
            expectations.removeValue(forKey: request)
        }
    }

    func makeExpectation(_ testCase: XCTestCase,
                         expectingURL url: String,
                         assertion: ((URLRequest) -> Bool)? = nil) {
        let expectation = ExpectedRequest(url: url, assertion: assertion)
        let frameworkExpectation = testCase.expectation(description: "Expected to load url \"\(url)\"")
        expectations[expectation] = frameworkExpectation
    }
    
    func stubResponse(for url: String, with data: Data) {
        stubbedResponses[url] = data
    }
    
    func stubbedResponseData(for url: String) -> Data? {
        return stubbedResponses[url]
    }
    
    func stubError(for url: String, with error: Error) {
        stubbedErrors[url] = error
    }
    
    func stubbedResponseError(for url: String) -> Error? {
        return stubbedErrors[url]
    }

}

class TestURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    override init(request: URLRequest,
         cachedResponse: CachedURLResponse?,
         client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        JournallingURLRequestLogger.shared.record(request)
    }

    override func startLoading() {
        let url = request.url?.absoluteString ?? ""
        
        if let error = JournallingURLRequestLogger.shared.stubbedResponseError(for: url) {
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
        }
        else {
            let data = JournallingURLRequestLogger.shared.stubbedResponseData(for: url) ?? Data()
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {

    }

}

class URLSessionBasedJSONSessionTests: XCTestCase {
    
    private let testTimeout: TimeInterval = 0.5

    override func setUp() {
        super.setUp()
        JournallingURLRequestLogger.shared.setUp()
    }
    
    private func post(_ url: String,
                      body: Data = Data(),
                      headers: [String : String] = [:],
                      completionHandler: ((Data?, Error?) -> Void)? = nil) {
        let poster = URLSessionBasedJSONSession()
        let request = JSONRequest(url: url, body: body, headers: headers)
        poster.post(request, completionHandler: { completionHandler?($0, $1) })
    }
    
    private func get(_ url: String,
                     body: Data = Data(),
                     headers: [String : String] = [:],
                     completionHandler: ((Data?, Error?) -> Void)? = nil) {
        let session = URLSessionBasedJSONSession()
        let request = JSONRequest(url: url, body: body, headers: headers)
        session.get(request, completionHandler: { completionHandler?($0, $1) })
    }
    
    func testPostingURLShouldRequestWithURL() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL)
        post(expectedURL)

        waitForExpectations(timeout: testTimeout)
    }

    func testPostingURLShouldRequestWithPOSTHTTPMethod() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.httpMethod == "POST"
        }

        post(expectedURL)

        waitForExpectations(timeout: testTimeout)
    }

    func testPostingURLShouldProvideBodyWithRequest() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedData = "Body contents".data(using: .utf8)!
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            guard let stream = request.httpBodyStream else { return false }

            stream.open()
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

            defer {
                buffer.deallocate()
                stream.close()
            }

            var data = Data()
            while stream.hasBytesAvailable {
                let read = stream.read(buffer, maxLength: bufferSize)
                data.append(buffer, count: read)
            }

            return expectedData == data
        }

        post(expectedURL, body: expectedData)

        waitForExpectations(timeout: testTimeout)
    }
    
    func testPostingURLShouldUseJSONContentTypeHeader() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedContentType = "application/json"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.allHTTPHeaderFields?["Content-Type"] == expectedContentType
        }
        
        post(expectedURL)
        
        waitForExpectations(timeout: testTimeout)
    }
    
    func testPostingURLWithAdditionalHeadersSuppliesThemWithTheRequest() {
        let additionalHeaders = ["SomeHeader" : "SomeValue"]
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.allHTTPHeaderFields?["SomeHeader"] == "SomeValue"
        }
        
        post(expectedURL, headers: additionalHeaders)
        waitForExpectations(timeout: testTimeout)
    }
    
    func testLoadingCompletesSuppliesResponseDataToCompletionHandler() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedResponseData = "Response".data(using: .utf8)!
        JournallingURLRequestLogger.shared.stubResponse(for: expectedURL, with: expectedResponseData)
        
        let matchingDataExpectation = expectation(description: "Returned data from response")
        post(expectedURL, completionHandler: { data, _ in
            if expectedResponseData == data {
                matchingDataExpectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: testTimeout)
    }
    
    func testLoadingCompletesSuppliesResponseDataOnMainQueue() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.stubResponse(for: expectedURL, with: Data())
        
        let correctQueueExpectation = expectation(description: "Completion handler should be called on the main queue")
        post(expectedURL, completionHandler: { (data, _) in
            if Thread.current.isMainThread {
                correctQueueExpectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: testTimeout)
    }
    
    func testGettingURLShouldRequestWithURL() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL)
        get(expectedURL)
        
        waitForExpectations(timeout: testTimeout)
    }
    
    func testGettingURLShouldRequestWithGETMethod() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.httpMethod == "GET"
        }
        
        get(expectedURL)
        
        waitForExpectations(timeout: testTimeout)
    }
    
    func testGettingURLShouldUseJSONContentTypeHeader() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedContentType = "application/json"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.allHTTPHeaderFields?["Content-Type"] == expectedContentType
        }
        
        get(expectedURL)
        
        waitForExpectations(timeout: testTimeout)
    }
    
    func testGettingURLWithAdditionalHeadersSuppliesThemWithTheRequest() {
        let additionalHeaders = ["SomeHeader" : "SomeValue"]
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.allHTTPHeaderFields?["SomeHeader"] == "SomeValue"
        }
        
        get(expectedURL, headers: additionalHeaders)
        waitForExpectations(timeout: testTimeout)
    }
    
    func testGetRequestCompletesSuppliesResponseDataToCompletionHandler() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedResponseData = "Response".data(using: .utf8)!
        JournallingURLRequestLogger.shared.stubResponse(for: expectedURL, with: expectedResponseData)
        
        let matchingDataExpectation = expectation(description: "Returned data from response")
        get(expectedURL, completionHandler: { data, _ in
            if expectedResponseData == data {
                matchingDataExpectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: testTimeout)
    }
    
    func testGettingCompletesSuppliesResponseDataOnMainQueue() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.stubResponse(for: expectedURL, with: Data())
        
        let correctQueueExpectation = expectation(description: "Completion handler should be called on the main queue")
        get(expectedURL, completionHandler: { (data, _) in
            if Thread.current.isMainThread {
                correctQueueExpectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testNetworkErrorOccursShouldPropagateErrorToCompletionHandler() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedError = NSError(domain: "Test", code: 0, userInfo: nil)
        JournallingURLRequestLogger.shared.stubError(for: expectedURL, with: expectedError)
        
        let errorExpectation = expectation(description: "Completion handler should be provided with error")
        get(expectedURL, completionHandler: { _, error in
            guard let error = error else { return }
            
            if (error as NSError) == expectedError {
                errorExpectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: testTimeout)
    }
    
}
