import EurofurenceModel
import UIKit

public struct DealerActivityItemSource: Equatable {
    
    public static func == (lhs: DealerActivityItemSource, rhs: DealerActivityItemSource) -> Bool {
        lhs.dealer.identifier == rhs.dealer.identifier
    }
    
    public var dealer: Dealer
    
    public init(dealer: Dealer) {
        self.dealer = dealer
    }
    
}
