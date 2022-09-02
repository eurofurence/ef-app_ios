import Foundation

extension FileManager {
    
    var sharedContainerURL: URL {
        guard let url = containerURL(forSecurityApplicationGroupIdentifier: SecurityGroup.identifier) else {
            fatalError("Couldn't resolve URL for shared container")
        }

        return url
    }
    
    var modelDirectory: URL {
        sharedContainerURL.appendingPathComponent("Model")
    }
    
}
