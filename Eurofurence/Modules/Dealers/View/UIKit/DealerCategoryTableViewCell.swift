import UIKit

class DealerCategoryTableViewCell: UITableViewCell, DealerCategoryComponentScene {
    
    func setCategoryTitle(_ title: String) {
        textLabel?.text = title
    }
    
    private var selectionHandler: (() -> Void)?
    func setSelectionHandler(_ handler: @escaping () -> Void) {
        selectionHandler = handler
    }
    
    func showActiveCategoryIndicator() {
        accessoryType = .checkmark
    }
    
    func hideActiveCategoryIndicator() {
        accessoryType = .none
    }
    
    func selected() {
        selectionHandler?()
    }
    
}
