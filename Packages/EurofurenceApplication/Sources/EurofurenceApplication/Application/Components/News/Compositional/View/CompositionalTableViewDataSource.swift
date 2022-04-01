import UIKit

public protocol TableViewMediator: UITableViewDataSource, UITableViewDelegate {
    
    func registerReusableViews(into tableView: UITableView)
    
}

public class CompositionalTableViewDataSource: NSObject {
    
    private let tableView: UITableView
    private let missingNumeric = UITableView.noIntrinsicMetric
    private var mediators = [TableViewMediator]()
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.dataSource = self
    }
    
    public func append(_ dataSource: TableViewMediator) {
        mediators.append(dataSource)
        dataSource.registerReusableViews(into: tableView)
        tableView.insertSections([mediators.count - 1], with: .automatic)
    }
    
}

// MARK: - CompositionalTableViewDataSource + UITableViewDataSource

extension CompositionalTableViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        mediators.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mediator = mediators[section]
        return mediator.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mediator = mediators[indexPath.section]
        return mediator.tableView(tableView, cellForRowAt: indexPath)
    }
    
}

// MARK: - CompositionalTableViewDataSource + UITableViewDelegate

extension CompositionalTableViewDataSource: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediator = mediators[indexPath.section]
        mediator.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mediator = mediators[section]
        return mediator.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let mediator = mediators[section]
        return mediator.tableView?(tableView, viewForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let mediator = mediators[section]
        return mediator.tableView?(tableView, estimatedHeightForHeaderInSection: section) ?? missingNumeric
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let mediator = mediators[indexPath.section]
        return mediator.tableView?(tableView, estimatedHeightForRowAt: indexPath) ?? missingNumeric
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mediator = mediators[indexPath.section]
        return mediator.tableView?(tableView, heightForRowAt: indexPath) ?? missingNumeric
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let mediator = mediators[section]
        return mediator.tableView?(tableView, titleForFooterInSection: section)
    }
    
    public func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let mediator = mediators[indexPath.section]
        return mediator.tableView?(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
    
    public func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let mediator = mediators[indexPath.section]
        return mediator.tableView?(tableView, contextMenuConfigurationForRowAt: indexPath, point: point)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for mediator in mediators {
            mediator.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
    
}
