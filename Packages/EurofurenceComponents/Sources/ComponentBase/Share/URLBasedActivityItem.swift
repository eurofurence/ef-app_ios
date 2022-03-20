import LinkPresentation
import UIKit

open class URLBasedActivityItem: NSObject, UIActivityItemSource {
    
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        url
    }
    
    public func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        url
    }
    
    public func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.url = url
        
        if let appIcon = UIImage(named: "Eurofurence Link Metadata Share Icon", in: .module, compatibleWith: nil) {
            metadata.iconProvider = NSItemProvider(object: appIcon)
        }
        
        supplementLinkMetadata(metadata)
        
        return metadata
    }
    
    open func supplementLinkMetadata(_ metadata: LPLinkMetadata) {
        
    }
    
}
