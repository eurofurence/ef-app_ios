import EurofurenceWebAPI
import Foundation

public protocol EurofurenceModelProperties: AnyObject {
    
    var containerDirectoryURL: URL { get }
    var synchronizationChangeToken: SynchronizationPayload.GenerationToken? { get set }
    
}

extension EurofurenceModelProperties {
    
    public var eurofurenceKitDirectory: URL {
        containerDirectoryURL.appendingPathComponent("EurofurenceKit")
    }
    
    public var persistentStoreDirectory: URL {
        eurofurenceKitDirectory.appendingPathComponent("Database")
    }
    
    public var imagesDirectory: URL {
        eurofurenceKitDirectory.appendingPathComponent("Images")
    }
    
}
