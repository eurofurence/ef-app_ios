import UIKit

class DealerCategoriesViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DealerCategoryTableViewCell.self)
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: DealerCategoryTableViewCell = tableView.customCellForRow(at: indexPath)
        cell.showCategoryActiveIndicator()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: DealerCategoryTableViewCell = tableView.customCellForRow(at: indexPath)
        cell.hideCategoryActiveIndicator()
    }

}
