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

    static let shared = JournallingURLRequestLogger()
    private var expectations = [String : XCTestExpectation]()

    func setUp() {
        URLProtocol.registerClass(TestURLProtocol.self)
        expectations.removeAll()
    }

    func record(_ request: URLRequest) {
        guard let url = request.url,
              let expectation = expectations[url.absoluteString] else { return }

        expectations[url.absoluteString] = nil
        expectation.fulfill()
    }

    func makeExpectation(_ testCase: XCTestCase, expectingURL url: String) {
        let expectation = testCase.expectation(description: "Expected to load url \"\(url)\"")
        expectations[url] = expectation
    }

}

class TestURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
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

        let request = URLRequest(url: actualURL)
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
    
}
