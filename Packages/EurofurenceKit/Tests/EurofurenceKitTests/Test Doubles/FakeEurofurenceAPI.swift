import EurofurenceKit
import EurofurenceWebAPI
import Foundation

class FakeEurofurenceAPI: EurofurenceAPI {
    
    var nextSyncResponse: Result<SynchronizationPayload, Error>?
    private(set) var lastChangeToken: SynchronizationPayload.GenerationToken?
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload {
        lastChangeToken = previousChangeToken
        
        struct NotStubbed: Error { }
        
        guard let nextSyncResponse = nextSyncResponse else {
            throw NotStubbed()
        }

        switch nextSyncResponse {
        case .success(let payload):
            return payload
            
        case .failure(let error):
            throw error
        }
    }
    
    private(set) var requestedImages = [DownloadImageRequest]()
    private var imageDownloadResultsByIdentifier = [String: Result<Void, Error>]()
    func downloadImage(_ request: DownloadImageRequest) async throws {
        requestedImages.append(request)
        
        if case .failure(let error) = imageDownloadResultsByIdentifier[request.imageIdentifier] {
            throw error
        }
    }
    
    func stub(_ result: Result<Void, Error>, forImageIdentifier imageIdentifier: String) {
        imageDownloadResultsByIdentifier[imageIdentifier] = result
    }
    
}
