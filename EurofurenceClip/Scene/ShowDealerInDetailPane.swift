import ComponentBase
import DealerComponent
import DealersComponent
import EurofurenceModel
import UIKit

struct ShowDealerInDetailPane: DealersComponentDelegate {
    
    var splitViewController: UISplitViewController
    var dealerDetailModuleProviding: DealerDetailComponentFactory
    
    func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        let dealerDetailComponent = dealerDetailModuleProviding.makeDealerDetailComponent(for: identifier)
        splitViewController.showDetailViewController(
            dealerDetailComponent,
            sender: DetailPresentationContext.replace
        )
    }
    
}
