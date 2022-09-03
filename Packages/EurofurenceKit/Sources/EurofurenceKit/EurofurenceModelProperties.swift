import EurofurenceWebAPI
import Foundation

public protocol EurofurenceModelProperties: AnyObject {
    
    var containerDirectoryURL: URL { get }
    var synchronizationChangeToken: SynchronizationPayload.GenerationToken? { get set }
    
    func proposedURL(forImageIdentifier identifier: String) -> URL
    
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
    
    public func proposedURL(forImageIdentifier identifier: String) -> URL {
        imagesDirectory.appendingPathComponent(identifier)
    }
    
}
