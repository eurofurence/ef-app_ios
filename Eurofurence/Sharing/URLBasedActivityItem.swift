import LinkPresentation
import UIKit

public class URLBasedActivityItem: NSObject, UIActivityItemSource {
    
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        url
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        url
    }
    
    @available(iOS 13.0, *)
    public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.url = url
        
        return metadata
    }
    
}
