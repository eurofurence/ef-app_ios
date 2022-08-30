import Foundation

extension FileManager {
    
    var sharedContainerURL: URL {
        let securityGroupIdentifier = "group.org.eurofurence.shared-container"
        guard let url = containerURL(forSecurityApplicationGroupIdentifier: securityGroupIdentifier) else {
            fatalError("Couldn't resolve URL for shared container")
        }

        return url
    }
    
    var modelDirectory: URL {
        sharedContainerURL.appendingPathComponent("Model")
    }
    
}
