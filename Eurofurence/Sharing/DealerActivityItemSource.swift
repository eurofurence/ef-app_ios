import EurofurenceModel
import UIKit

public class DealerActivityItemSource: URLBasedActivityItem {
    
    public var dealer: Dealer
    
    public init(dealer: Dealer) {
        self.dealer = dealer
        super.init(url: dealer.makeContentURL())
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? DealerActivityItemSource else { return false }
        return dealer.identifier == other.dealer.identifier
    }
    
}
