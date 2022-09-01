import EurofurenceWebAPI

public protocol EurofurenceModelProperties: AnyObject {
    
    var synchronizationChangeToken: SynchronizationPayload.GenerationToken? { get set }
    
}
