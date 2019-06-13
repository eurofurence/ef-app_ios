import EurofurenceModel
import XCTest

class URLSessionBasedJSONSessionTests: XCTestCase {

    private let testTimeout: TimeInterval = 1

    override func setUp() {
        super.setUp()
        JournallingURLRequestLogger.shared.setUp()
    }

    private func post(_ url: String,
                      body: Data = Data(),
                      headers: [String: String] = [:],
                      completionHandler: ((Data?, Error?) -> Void)? = nil) {
        let poster = URLSessionBasedJSONSession()
        let request = JSONRequest(url: url, body: body, headers: headers)
        poster.post(request, completionHandler: { completionHandler?($0, $1) })
    }

    private func get(_ url: String,
                     body: Data = Data(),
                     headers: [String: String] = [:],
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
        let expectedData = unwrap("Body contents".data(using: .utf8))
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
        let additionalHeaders = ["SomeHeader": "SomeValue"]
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.allHTTPHeaderFields?["SomeHeader"] == "SomeValue"
        }

        post(expectedURL, headers: additionalHeaders)
        waitForExpectations(timeout: testTimeout)
    }

    func testLoadingCompletesSuppliesResponseDataToCompletionHandler() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedResponseData = unwrap("Response".data(using: .utf8))
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
        post(expectedURL, completionHandler: { (_, _) in
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
        let additionalHeaders = ["SomeHeader": "SomeValue"]
        let expectedURL = "https://www.somewhere.co.uk"
        JournallingURLRequestLogger.shared.makeExpectation(self, expectingURL: expectedURL) { request in
            return request.allHTTPHeaderFields?["SomeHeader"] == "SomeValue"
        }

        get(expectedURL, headers: additionalHeaders)
        waitForExpectations(timeout: testTimeout)
    }

    func testGetRequestCompletesSuppliesResponseDataToCompletionHandler() {
        let expectedURL = "https://www.somewhere.co.uk"
        let expectedResponseData = unwrap("Response".data(using: .utf8))
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
        get(expectedURL, completionHandler: { (_, _) in
            if Thread.current.isMainThread {
                correctQueueExpectation.fulfill()
            }
        })

        waitForExpectations(timeout: testTimeout)
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
