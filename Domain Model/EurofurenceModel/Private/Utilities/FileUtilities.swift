import Foundation

struct FileUtilities {

    static var sharedContainerURL: URL {
        let fileManager = FileManager.default
        let securityGroupIdentifier = "group.org.eurofurence.shared-container"
        guard let securityContainer = fileManager.containerURL(forSecurityApplicationGroupIdentifier: securityGroupIdentifier) else {
            fatalError("Couldn't resolve URL for shared container")
        }

        return securityContainer
    }

}
