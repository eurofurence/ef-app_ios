import EurofurenceApplication
import UIKit

class FakeTableViewMediator: NSObject, TableViewMediator {
    
    weak var delegate: TableViewMediatorDelegate?
    
    private(set) var tableViewForReusableViewRegistration: UITableView?
    func registerReusableViews(into tableView: UITableView) {
        tableViewForReusableViewRegistration = tableView
    }
    
    var numberOfRows = 0 {
        didSet {
            delegate?.dataSourceContentsDidChange(self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cells[indexPath, default: UITableViewCell()]
    }
    
    private(set) var selectedIndexPath: IndexPath?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
    
    private var cells = [IndexPath: UITableViewCell]()
    func stub(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cells[indexPath] = cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        estimatedSectionHeaderHeights[section, default: -1]
    }
    
    private var estimatedSectionHeaderHeights = [Int: CGFloat]()
    func stub(_ estimatedHeight: CGFloat, asEstimatedHeightForHeaderInSection sectionIndex: Int) {
        estimatedSectionHeaderHeights[sectionIndex] = estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeaderViews[section]
    }
    
    private var sectionHeaderViews = [Int: UIView]()
    func stub(_ headerView: UIView, asViewForHeaderInSection sectionIndex: Int) {
        sectionHeaderViews[sectionIndex] = headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sectionFooterViews[section]
    }
    
    private var sectionFooterViews = [Int: UIView]()
    func stub(_ footerView: UIView, asViewForFooterInSection sectionIndex: Int) {
        sectionFooterViews[sectionIndex] = footerView
    }
    
    private var heightsForFooters = [Int: CGFloat]()
    func stub(_ footerHeight: CGFloat, asHeightForFooterInSection sectionIndex: Int) {
        heightsForFooters[sectionIndex] = footerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        heightsForFooters[section] ?? 0
    }
    
    private var estimatedHeightsForRows = [IndexPath: CGFloat]()
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        estimatedHeightsForRows[indexPath, default: -1]
    }
    
    func stub(_ estimatedRowHeight: CGFloat, asEstimatedHeightForRowAt indexPath: IndexPath) {
        estimatedHeightsForRows[indexPath] = estimatedRowHeight
    }
    
    private var heightsForRows = [IndexPath: CGFloat]()
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightsForRows[indexPath, default: -1]
    }
    
    func stub(_ rowHeight: CGFloat, asHeightForRowAt indexPath: IndexPath) {
        heightsForRows[indexPath] = rowHeight
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sectionFooterTitles[section]
    }
    
    private var sectionFooterTitles = [Int: String]()
    func stub(_ footerTitle: String, asTitleForFooterInSection sectionIndex: Int) {
        sectionFooterTitles[sectionIndex] = footerTitle
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        contextMenuConfigurations[indexPath]
    }
    
    private var contextMenuConfigurations = [IndexPath: UIContextMenuConfiguration]()
    func stub(
        _ contextMenuConfiguration: UIContextMenuConfiguration,
        asContextMenuConfigurationForRowAt indexPath: IndexPath
    ) {
        contextMenuConfigurations[indexPath] = contextMenuConfiguration
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        trailingSwipeActionsConfigurations[indexPath]
    }
    
    private var trailingSwipeActionsConfigurations = [IndexPath: UISwipeActionsConfiguration]()
    func stub(
        _ trailingSwipeActionsConfiguration: UISwipeActionsConfiguration,
        asTrailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) {
        trailingSwipeActionsConfigurations[indexPath] = trailingSwipeActionsConfiguration
    }
    
    private(set) var notifiedScrollViewDidEndDragging = false
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        notifiedScrollViewDidEndDragging = true
    }
    
}
