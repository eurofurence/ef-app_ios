import Foundation
import XCTest

class JournallingURLRequestLogger {

    struct ExpectedRequest: Hashable {
        var url: String
        var assertion: ((URLRequest) -> Bool)?

        func hash(into hasher: inout Hasher) {
            hasher.combine(url)
        }

        static func == (lhs: ExpectedRequest, rhs: ExpectedRequest) -> Bool {
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
    private var expectations = [ExpectedRequest: XCTestExpectation]()
    private var stubbedResponses = [String: Data]()
    private var stubbedErrors = [String: Error]()

    func setUp() {
        URLProtocol.registerClass(TestURLProtocol.self)
        expectations.removeAll()
    }

    func record(_ request: URLRequest) {
        var requestsToRemove = [ExpectedRequest]()
        for (expectedRequest, expectation) in expectations where expectedRequest.expected(request) {
            expectation.fulfill()
            requestsToRemove.append(expectedRequest)
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
