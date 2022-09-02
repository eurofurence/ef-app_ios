import Foundation

public struct ImageFetchRequest: Equatable, Hashable {
    
    var imageIdentifier: String
    var lastKnownImageContentHashSHA1: String
    
    public init(imageIdentifier: String, lastKnownImageContentHashSHA1: String) {
        self.imageIdentifier = imageIdentifier
        self.lastKnownImageContentHashSHA1 = lastKnownImageContentHashSHA1
    }
    
}

public protocol EurofurenceAPI {
    
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload
    
    func fetchImage(_ request: ImageFetchRequest)
    
}
