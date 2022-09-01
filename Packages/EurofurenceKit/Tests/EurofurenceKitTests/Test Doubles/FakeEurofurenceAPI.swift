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
    
}
