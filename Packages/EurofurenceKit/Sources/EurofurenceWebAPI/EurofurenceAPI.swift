import Foundation

public protocol EurofurenceAPI {
    
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload
    
}
