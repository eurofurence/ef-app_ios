import UIKit

class DealerCategoryTableViewCell: UITableViewCell, DealerCategoryComponentScene {
    
    func setCategoryTitle(_ title: String) {
        textLabel?.text = title
    }
    
    func setSelectionHandler(_ handler: @escaping () -> Void) {
        
    }
    
    func showActiveCategoryIndicator() {
        accessoryType = .checkmark
    }
    
    func hideActiveCategoryIndicator() {
        accessoryType = .none
    }
    
}
