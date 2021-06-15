import DealersComponent
import UIKit

public struct StubDealersComponentFactory: DealersComponentFactory {
    
    public init() {
        
    }
    
    public let module = UIViewController()
    public func makeDealersComponent(_ delegate: DealersComponentDelegate) -> UIViewController {
        module
    }
    
}
