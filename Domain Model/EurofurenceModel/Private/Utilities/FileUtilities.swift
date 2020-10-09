import Foundation

struct FileUtilities {

    static var sharedContainerURL: URL {
        let fileManager = FileManager.default
        let securityGroupIdentifier = "group.org.eurofurence.shared-container"
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: securityGroupIdentifier)
        guard let securityContainer = containerURL else {
            fatalError("Couldn't resolve URL for shared container")
        }

        return securityContainer
    }

}
