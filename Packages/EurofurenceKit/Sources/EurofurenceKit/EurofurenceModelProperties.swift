import EurofurenceWebAPI
import Foundation

public protocol EurofurenceModelProperties: AnyObject {
    
    var containerDirectoryURL: URL { get }
    var synchronizationChangeToken: SynchronizationPayload.GenerationToken? { get set }
    
}
