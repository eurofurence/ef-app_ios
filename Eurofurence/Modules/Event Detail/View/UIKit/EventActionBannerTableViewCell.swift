import UIKit

class EventActionBannerTableViewCell: UITableViewCell, EventActionBannerComponent {
    
    @IBOutlet private weak var bannerActionButton: UIButton!
    @IBOutlet private weak var popoverAnchorView: UIView!
    
    func setActionTitle(_ title: String) {
        bannerActionButton.setTitle(title, for: .normal)
    }
    
    private var handler: ((Any) -> Void)?
    func setSelectionHandler(_ handler: @escaping (Any) -> Void) {
        self.handler = handler
    }
    
    @IBAction private func performBannerAction() {
        handler?(popoverAnchorView as Any)
    }
    
}
