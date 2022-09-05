@testable import EurofurenceWebAPI
import XCTest

class CIDSensitiveEurofurenceAPITests: XCTestCase {
    
    func testSyncWithoutTimestampUsesExpectedURL() async throws {
        let network = FakeNetwork()
        let expectedURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        let bundle = Bundle.module
        let responseFileURL = try XCTUnwrap(bundle.url(forResource: "EF26FullSyncResponse", withExtension: "json"))
        let responseFileData = try Data(contentsOf: responseFileURL)
        network.stub(url: expectedURL, with: .success(responseFileData))
        let api = CIDSensitiveEurofurenceAPI(network: network)
        _ = try await api.fetchChanges(since: nil)
        
        let expected = FakeNetwork.Event.get(url: expectedURL)
        XCTAssertEqual([expected], network.history)
    }
    
    func testSyncWithTimestampUsesExpectedURL() async throws {
        let network = FakeNetwork()
        let lastSyncTime = Date()
        let generationToken = SynchronizationPayload.GenerationToken(lastSyncTime: lastSyncTime)
        let formattedSyncTime = EurofurenceISO8601DateFormatter.instance.string(from: lastSyncTime)
        let expectedURLString = "https://app.eurofurence.org/EF26/api/Sync?since=\(formattedSyncTime)"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        let bundle = Bundle.module
        let responseFileURL = try XCTUnwrap(bundle.url(forResource: "EF26FullSyncResponse", withExtension: "json"))
        let responseFileData = try Data(contentsOf: responseFileURL)
        network.stub(url: expectedURL, with: .success(responseFileData))
        let api = CIDSensitiveEurofurenceAPI(network: network)
        _ = try await api.fetchChanges(since: generationToken)
        
        let expected = FakeNetwork.Event.get(url: expectedURL)
        XCTAssertEqual([expected], network.history)
    }
    
    func testDownloadingImageSuccess_WritesDataToURL() async throws {
        let network = FakeNetwork()
        let temporaryFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("Image")
        
        addTeardownBlock {
            try FileManager.default.removeItem(at: temporaryFileURL)
        }
        
        let imageRequest = DownloadImage(
            imageIdentifier: "ID",
            lastKnownImageContentHashSHA1: "SHA",
            downloadDestinationURL: temporaryFileURL
        )
        
        let expectedImageEndpointString = "https://app.eurofurence.org/EF26/api/Images/ID/Content/with-hash:SHA"
        let expectedImageEndpoint = try XCTUnwrap(URL(string: expectedImageEndpointString))
        let pretendImageData = try XCTUnwrap("🎆".data(using: .utf8))
        network.stubDownload(of: expectedImageEndpoint, with: .success(pretendImageData))
        let api = CIDSensitiveEurofurenceAPI(network: network)
        try await api.downloadImage(imageRequest)
        
        let downloadedImageData = try Data(contentsOf: temporaryFileURL)
        XCTAssertEqual(downloadedImageData, pretendImageData)
    }
    
    func testDownloadingImageSuccess_FileAlreadyExists_NewImageOverwritesOldFile() async throws {
        let network = FakeNetwork()
        let temporaryFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("Image")
        
        addTeardownBlock {
            try FileManager.default.removeItem(at: temporaryFileURL)
        }
        
        let imageRequest = DownloadImage(
            imageIdentifier: "ID",
            lastKnownImageContentHashSHA1: "SHA",
            downloadDestinationURL: temporaryFileURL
        )
        
        let existingData = try XCTUnwrap("👀".data(using: .utf8))
        try existingData.write(to: temporaryFileURL)
        
        let expectedImageEndpointString = "https://app.eurofurence.org/EF26/api/Images/ID/Content/with-hash:SHA"
        let expectedImageEndpoint = try XCTUnwrap(URL(string: expectedImageEndpointString))
        let pretendImageData = try XCTUnwrap("🎆".data(using: .utf8))
        network.stubDownload(of: expectedImageEndpoint, with: .success(pretendImageData))
        let api = CIDSensitiveEurofurenceAPI(network: network)
        try await api.downloadImage(imageRequest)
        
        let downloadedImageData = try Data(contentsOf: temporaryFileURL)
        XCTAssertEqual(downloadedImageData, pretendImageData)
    }
    
    func testSignIn_Success() async throws {
        let network = FakeNetwork()
        let api = CIDSensitiveEurofurenceAPI(network: network)
        
        let login = Login(registrationNumber: 42, username: "Some Guy", password: "p4s5w0rd")
        let expectedURLString = "https://app.eurofurence.org/EF26/api/Token/SysReg"
        let expectedURL = try XCTUnwrap(URL(string: expectedURLString))
        
        let bundle = Bundle.module
        let expectedBodyURL = try XCTUnwrap(bundle.url(forResource: "ExpectedLoginBody", withExtension: "json"))
        let expectedBodyData = try Data(contentsOf: expectedBodyURL)
        let expectedRequest = NetworkRequest(url: expectedURL, body: expectedBodyData, method: .post)
        
        let expectedResponseURL = try XCTUnwrap(bundle.url(
            forResource: "ExpectedSuccessfulLoginBody",
            withExtension: "json"
        ))
        
        let expectedResponseData = try Data(contentsOf: expectedResponseURL)
        
        network.stub(expectedRequest, with: .success(expectedResponseData))
        
        let authenticatedUser = try await api.requestAuthenticationToken(using: login)
        let formatter = EurofurenceISO8601DateFormatter.instance
        let expirationDate = try XCTUnwrap(formatter.date(from: "2022-09-04T21:23:36.780Z"))
        let expectedUser = AuthenticatedUser(
            userIdentifier: 108,
            username: "Username",
            token: "Token",
            tokenExpires: expirationDate
        )
        
        XCTAssertEqual(expectedUser, authenticatedUser)
    }

}
