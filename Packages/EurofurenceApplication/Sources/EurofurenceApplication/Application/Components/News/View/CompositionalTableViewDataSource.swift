import UIKit

public protocol TableViewMediatorDelegate: AnyObject {
    
    func dataSourceContentsDidChange(_ dataSource: TableViewMediator)
    
}

public protocol TableViewMediator: UITableViewDataSource, UITableViewDelegate {
    
    /* weak */ var delegate: TableViewMediatorDelegate? { get set }
    
    func registerReusableViews(into tableView: UITableView)
    
}

@objcMembers
public class CompositionalTableViewDataSource: NSObject {
    
    private let tableView: UITableView
    private let missingNumeric = UITableView.automaticDimension
    private var mediators = [TableViewMediator]()
    private var delegates = [ReloadSectionWhenDataSourceChanges]()
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    public func append(_ dataSource: TableViewMediator) {
        insertNewSection(dataSource)
        registerReloadSectionWhenDataSourceChangesHandler(dataSource)
    }
    
    private func isSectionEmpty(_ section: Int) -> Bool {
        self.tableView(tableView, numberOfRowsInSection: section) == 0
    }
    
    private func insertNewSection(_ dataSource: TableViewMediator) {
        tableView.beginUpdates()
        mediators.append(dataSource)
        dataSource.registerReusableViews(into: tableView)
        tableView.insertSections([mediators.count - 1], with: .automatic)
        tableView.endUpdates()
    }
    
    private func registerReloadSectionWhenDataSourceChangesHandler(_ dataSource: TableViewMediator) {
        let reloadSectionHandler = ReloadSectionWhenDataSourceChanges { [weak self] (dataSource) in
            if let index = self?.mediators.firstIndex(where: { $0 === dataSource }) {
                self?.tableView.reloadSections([index], with: .automatic)
            }
        }
        
        delegates.append(reloadSectionHandler)
        dataSource.delegate = reloadSectionHandler
    }
    
    private class ReloadSectionWhenDataSourceChanges: TableViewMediatorDelegate {
        
        private let reloadSectionHandler: (TableViewMediator) -> Void
        
        init(reloadSectionHandler: @escaping (TableViewMediator) -> Void) {
            self.reloadSectionHandler = reloadSectionHandler
        }
        
        func dataSourceContentsDidChange(_ dataSource: TableViewMediator) {
            reloadSectionHandler(dataSource)
        }
        
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mediator = mediators[indexPath.section]
        mediator.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard isSectionEmpty(section) == false else { return nil }
        
        let mediator = mediators[section]
        return mediator.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let mediator = mediators[section]
        return mediator.tableView?(tableView, viewForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let mediator = mediators[section]
        return mediator.tableView?(tableView, heightForFooterInSection: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard isSectionEmpty(section) == false else { return 0 }
                
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
