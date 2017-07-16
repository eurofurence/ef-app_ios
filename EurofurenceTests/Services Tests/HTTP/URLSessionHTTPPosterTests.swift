//
//  URLSessionHTTPPosterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
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

    }

    override func stopLoading() {

    }

}

struct URLSessionHTTPPoster: HTTPPoster {

    var session: URLSession = .shared

    func post(_ url: String, body: Data) {
        guard let actualURL = URL(string: url) else { return }

        var request = URLRequest(url: actualURL)
        request.httpMethod = "POST"
        request.httpBody = body
        session.dataTask(with: request, completionHandler: { (_, _, _) in }).resume()
    }

}

class URLSessionHTTPPosterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        JournallingURLRequestLogger.shared.setUp()
    }
    
    func testPostingURLShouldPostRequestWithURL() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL)
        let poster = URLSessionHTTPPoster()
        poster.post(expectedURL, body: Data())

        waitForExpectations(timeout: 0.1)
    }

    func testPostingURLShouldPostRequestWithPOSTHTTPMethod() {
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.httpMethod == "POST"
        }

        let poster = URLSessionHTTPPoster()
        poster.post(expectedURL, body: Data())

        waitForExpectations(timeout: 0.1)
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
                buffer.deallocate(capacity: bufferSize)
                stream.close()
            }

            var data = Data()
            while stream.hasBytesAvailable {
                let read = stream.read(buffer, maxLength: bufferSize)
                data.append(buffer, count: read)
            }

            return expectedData == data
        }

        let poster = URLSessionHTTPPoster()
        poster.post(expectedURL, body: expectedData)

        waitForExpectations(timeout: 0.1)
    }
    
}
