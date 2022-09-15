import EurofurenceWebAPI
import Foundation

class PreviewingModelProperties: EurofurenceModelProperties {
    
    var containerDirectoryURL: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("EurofurenceKitPreview")
    }
    
    var synchronizationChangeToken: SynchronizationPayload.GenerationToken?
    
    func removeContainerResource(at url: URL) throws {
        
    }
    
    func proposedURL(forImageIdentifier identifier: String) -> URL {
        let bundle = Bundle.previewing
        let url = bundle.url(forResource: identifier, withExtension: nil)
        
        if let url = url {
            return url
        } else {
            fatalError(
                "Requested preview URL for image not present in preview bundle. ID=\(identifier)"
            )
        }
    }
    
}
