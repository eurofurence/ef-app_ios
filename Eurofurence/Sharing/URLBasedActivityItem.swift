import UIKit

public class URLBasedActivityItem: NSObject, UIActivityItemSource {
    
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        url
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        url
    }
    
}
