import EurofurenceApplication
import RouterCore
import UIKit

class FakeNewsWidgetManager: NewsWidgetEnvironment {
    
    private let tableView: UITableView
    private(set) var installedDataSources = [TableViewMediator]()
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    var router: Router = Routes()
    
    func install(dataSource: TableViewMediator) {
        installedDataSources.append(dataSource)
        dataSource.registerReusableViews(into: tableView)
    }
    
}
