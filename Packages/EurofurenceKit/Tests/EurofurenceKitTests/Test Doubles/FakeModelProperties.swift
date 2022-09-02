import EurofurenceKit
import EurofurenceWebAPI
import Foundation

class FakeModelProperties: EurofurenceModelProperties {
    
    var containerDirectoryURL: URL { URL(fileURLWithPath: "file://") }
    var synchronizationChangeToken: SynchronizationPayload.GenerationToken?
    
}
