import EurofurenceKit
import EurofurenceWebAPI
import Foundation

class FakeEurofurenceAPI: EurofurenceAPI {
    
    var nextSyncResponse: Result<SynchronizationPayload, Error>?
    private(set) var lastSyncTime: Date?
    func executeSyncRequest(lastUpdateTime: Date?) async throws -> SynchronizationPayload {
        lastSyncTime = lastUpdateTime
        
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
