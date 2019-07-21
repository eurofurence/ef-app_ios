import UIKit

class DealerCategoriesViewController: UITableViewController, DealerCategoriesFilterScene {
    
    private class DataSource {
        
        var numberOfRows: Int {
            return 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
        
    }
    
    private class BindableDataSource: DataSource {
        
        private let numberOfCategories: Int
        private let binder: DealerCategoriesBinder
        
        init(numberOfCategories: Int, binder: DealerCategoriesBinder) {
            self.numberOfCategories = numberOfCategories
            self.binder = binder
        }
        
        override var numberOfRows: Int {
            return numberOfCategories
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeue(DealerCategoryTableViewCell.self)
            binder.bindCategoryComponent(cell, at: indexPath.row)
            
            return cell
        }
        
    }
    
    private var categoriesDataSource: DataSource = DataSource()
    
    func bind(_ numberOfCategories: Int, using binder: DealerCategoriesBinder) {
        categoriesDataSource = BindableDataSource(numberOfCategories: numberOfCategories, binder: binder)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesDataSource.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return categoriesDataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: DealerCategoryTableViewCell = tableView.customCellForRow(at: indexPath)
        cell.showActiveCategoryIndicator()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: DealerCategoryTableViewCell = tableView.customCellForRow(at: indexPath)
        cell.hideActiveCategoryIndicator()
    }

}
