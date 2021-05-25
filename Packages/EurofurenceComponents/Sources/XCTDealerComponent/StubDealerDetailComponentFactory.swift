import DealerComponent
import EurofurenceModel
import UIKit
import XCTEurofurenceModel

public class StubDealerDetailComponentFactory: DealerDetailComponentFactory {
    
    public init() {
        
    }

    public let stubInterface = UIViewController()
    public private(set) var capturedModel: DealerIdentifier?
    public func makeDealerDetailComponent(for dealer: DealerIdentifier) -> UIViewController {
        capturedModel = dealer
        return stubInterface
    }

}
