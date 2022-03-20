import ComponentBase
import EurofurenceModel
import LinkPresentation
import UIKit

public class DealerActivityItemSource: URLBasedActivityItem {
    
    public var dealer: Dealer
    
    public init(dealer: Dealer) {
        self.dealer = dealer
        super.init(url: dealer.contentURL)
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? DealerActivityItemSource else { return false }
        return dealer.identifier == other.dealer.identifier
    }
    
    override public func supplementLinkMetadata(_ metadata: LPLinkMetadata) {
        metadata.title = dealer.preferredName
    }
    
}
