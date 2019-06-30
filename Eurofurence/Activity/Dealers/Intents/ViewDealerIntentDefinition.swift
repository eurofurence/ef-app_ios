import EurofurenceModel
import Foundation

struct ViewDealerIntentDefinition: Equatable {
    
    var identifier: DealerIdentifier
    var dealerName: String
    
    init(identifier: DealerIdentifier, dealerName: String) {
        self.identifier = identifier
        self.dealerName = dealerName
    }
    
}
