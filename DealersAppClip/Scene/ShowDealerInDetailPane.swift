import ComponentBase
import DealerComponent
import DealersComponent
import EurofurenceModel
import StoreKit
import UIKit

struct ShowDealerInDetailPane: DealersComponentDelegate {
    
    var splitViewController: UISplitViewController
    var dealerDetailModuleProviding: DealerDetailComponentFactory
    var scene: UIWindowScene
    
    func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        let dealerDetailComponent = dealerDetailModuleProviding.makeDealerDetailComponent(for: identifier)
        splitViewController.showDetailViewController(
            dealerDetailComponent,
            sender: DetailPresentationContext.replace
        )
        
        let config = SKOverlay.AppClipConfiguration(position: .bottom)
        let overlay = SKOverlay(configuration: config)
        overlay.present(in: scene)
    }
    
}
