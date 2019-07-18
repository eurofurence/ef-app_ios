import UIKit

class DealerCategoryTableViewCell: UITableViewCell {
    
    func showCategoryActiveIndicator() {
        accessoryType = .checkmark
    }
    
    func hideCategoryActiveIndicator() {
        accessoryType = .none
    }
    
}
