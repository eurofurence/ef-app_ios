import Foundation

public protocol EurofurenceAPI {
    
    func executeSyncRequest(lastUpdateTime: Date?) async throws -> SynchronizationPayload
    
}
