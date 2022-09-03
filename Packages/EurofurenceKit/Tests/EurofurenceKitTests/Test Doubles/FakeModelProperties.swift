import EurofurenceKit
import EurofurenceWebAPI
import Foundation

class FakeModelProperties: EurofurenceModelProperties {
    
    var containerDirectoryURL: URL { URL(fileURLWithPath: "file://") }
    var synchronizationChangeToken: SynchronizationPayload.GenerationToken?
    
    private var removedContainerResources = Set<URL>()
    func removeContainerResource(at url: URL) throws {
        removedContainerResources.insert(url)
    }
    
    func removedContainerResource(at url: URL) -> Bool {
        removedContainerResources.contains(url)
    }
    
}
