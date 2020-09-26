import EurofurenceModel
import UIKit

public class DealerActivityItemSource: NSObject {
    
    public var dealer: Dealer
    
    public init(dealer: Dealer) {
        self.dealer = dealer
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? DealerActivityItemSource else { return false }
        return dealer.identifier == other.dealer.identifier
    }
    
}

// MARK: - UIActivityItemSource

extension DealerActivityItemSource: UIActivityItemSource {
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        dealer.makeContentURL()
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        dealer.makeContentURL()
    }
    
}
