import EurofurenceApplication
import UIKit
import XCTest

class CompositionalTableViewDataSourceTests: XCTestCase {
    
    private var composition: CompositionalTableViewDataSource!
    private var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        tableView = UITableView(frame: .zero)
        composition = CompositionalTableViewDataSource(tableView: tableView)
    }
    
    // MARK: Data source composition
    
    func testActsAsDelegateForTableView() {
        XCTAssertIdentical(composition, tableView.delegate)
    }
    
    func testAddingSectionAllowsItToRegisterReusableViews() {
        let mediator = FakeTableViewMediator()
        composition.append(mediator)
        
        XCTAssertIdentical(tableView, mediator.tableViewForReusableViewRegistration)
    }
    
    func testNumberOfSectionsEqualsNumberOfDataSources() {
        XCTAssertEqual(0, tableView.numberOfSections)
        
        composition.append(FakeTableViewMediator())
        
        XCTAssertEqual(1, tableView.numberOfSections)
    }
    
    func testNumberOfRowsInferredFromDataSource() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        firstDataSource.numberOfRows = 5
        secondDataSource.numberOfRows = 10
        
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        XCTAssertEqual(5, tableView.numberOfRows(inSection: 0))
        XCTAssertEqual(10, tableView.numberOfRows(inSection: 1))
    }
    
    func testCellInferredFromDataSource() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        let (firstCell, secondCell) = (UITableViewCell(), UITableViewCell())
        firstDataSource.stub(cell: firstCell, forRowAt: IndexPath(row: 0, section: 0))
        secondDataSource.stub(cell: secondCell, forRowAt: IndexPath(row: 0, section: 1))
        
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        XCTAssertIdentical(firstCell, composition.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)))
        XCTAssertIdentical(secondCell, composition.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1)))
    }
    
    // MARK: Table view delegate composition
    
    func testSelectedCellNotifiesDataSourceForSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let firstCellFirstSection = IndexPath(row: 0, section: 0)
        let firstCellSecondSection = IndexPath(row: 0, section: 1)
        composition.tableView(tableView, didSelectRowAt: firstCellFirstSection)
        
        XCTAssertEqual(firstCellFirstSection, firstDataSource.selectedIndexPath)
        XCTAssertNil(secondDataSource.selectedIndexPath)
        
        composition.tableView(tableView, didSelectRowAt: firstCellSecondSection)
        
        XCTAssertEqual(firstCellFirstSection, firstDataSource.selectedIndexPath)
        XCTAssertEqual(firstCellSecondSection, secondDataSource.selectedIndexPath)
    }
    
    func testEstimatedHeightForHeaderInSectionInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        firstDataSource.stub(44, asEstimatedHeightForHeaderInSection: 0)
        secondDataSource.stub(22, asEstimatedHeightForHeaderInSection: 1)
        
        XCTAssertEqual(44, composition.tableView(tableView, estimatedHeightForHeaderInSection: 0))
        XCTAssertEqual(22, composition.tableView(tableView, estimatedHeightForHeaderInSection: 1))
    }
    
    func testViewForHeaderInSectionInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let (firstHeader, secondHeader) = (UIView(), UIView())
        firstDataSource.stub(firstHeader, asViewForHeaderInSection: 0)
        secondDataSource.stub(secondHeader, asViewForHeaderInSection: 1)
        
        XCTAssertIdentical(firstHeader, composition.tableView(tableView, viewForHeaderInSection: 0))
        XCTAssertIdentical(secondHeader, composition.tableView(tableView, viewForHeaderInSection: 1))
    }
    
    func testViewForFooterInSectionInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let (firstHeader, secondHeader) = (UIView(), UIView())
        firstDataSource.stub(firstHeader, asViewForFooterInSection: 0)
        secondDataSource.stub(secondHeader, asViewForFooterInSection: 1)
        
        XCTAssertIdentical(firstHeader, composition.tableView(tableView, viewForFooterInSection: 0))
        XCTAssertIdentical(secondHeader, composition.tableView(tableView, viewForFooterInSection: 1))
    }
    
    func testEstimatedHeightForRowAtInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let firstCellFirstSection = IndexPath(row: 0, section: 0)
        let firstCellSecondSection = IndexPath(row: 0, section: 1)
        firstDataSource.stub(44, asEstimatedHeightForRowAt: firstCellFirstSection)
        secondDataSource.stub(22, asEstimatedHeightForRowAt: firstCellSecondSection)
        
        XCTAssertEqual(44, composition.tableView(tableView, estimatedHeightForRowAt: firstCellFirstSection))
        XCTAssertEqual(22, composition.tableView(tableView, estimatedHeightForRowAt: firstCellSecondSection))
    }
    
    func testHeightForRowAtInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let firstCellFirstSection = IndexPath(row: 0, section: 0)
        let firstCellSecondSection = IndexPath(row: 0, section: 1)
        firstDataSource.stub(44, asHeightForRowAt: firstCellFirstSection)
        secondDataSource.stub(22, asHeightForRowAt: firstCellSecondSection)
        
        XCTAssertEqual(44, composition.tableView(tableView, heightForRowAt: firstCellFirstSection))
        XCTAssertEqual(22, composition.tableView(tableView, heightForRowAt: firstCellSecondSection))
    }
    
    func testTitleForFooterInSectionInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        firstDataSource.stub("First section footer", asTitleForFooterInSection: 0)
        secondDataSource.stub("Second section footer", asTitleForFooterInSection: 1)
        
        XCTAssertEqual("First section footer", composition.tableView(tableView, titleForFooterInSection: 0))
        XCTAssertEqual("Second section footer", composition.tableView(tableView, titleForFooterInSection: 1))
    }
    
    func testTrailingSwipeActionsConfigurationForRowAtInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let firstCellFirstSection = IndexPath(row: 0, section: 0)
        let firstCellSecondSection = IndexPath(row: 0, section: 1)
        let (first, second) = (UISwipeActionsConfiguration(), UISwipeActionsConfiguration())
        
        firstDataSource.stub(first, asTrailingSwipeActionsConfigurationForRowAt: firstCellFirstSection)
        secondDataSource.stub(second, asTrailingSwipeActionsConfigurationForRowAt: firstCellSecondSection)
        
        XCTAssertIdentical(
            first,
            composition.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: firstCellFirstSection)
        )
        
        XCTAssertIdentical(
            second,
            composition.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: firstCellSecondSection)
        )
    }
    
    func testContextMenuConfigurationForRowAtInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let firstCellFirstSection = IndexPath(row: 0, section: 0)
        let firstCellSecondSection = IndexPath(row: 0, section: 1)
        let (first, second) = (UIContextMenuConfiguration(), UIContextMenuConfiguration())
        
        firstDataSource.stub(first, asContextMenuConfigurationForRowAt: firstCellFirstSection)
        secondDataSource.stub(second, asContextMenuConfigurationForRowAt: firstCellSecondSection)
        
        XCTAssertIdentical(
            first,
            composition.tableView(tableView, contextMenuConfigurationForRowAt: firstCellFirstSection, point: .zero)
        )
        
        XCTAssertIdentical(
            second,
            composition.tableView(tableView, contextMenuConfigurationForRowAt: firstCellSecondSection, point: .zero)
        )
    }
    
    // MARK: Scroll view delegate composition
    
    func testScrollViewDidEndDraggingPropogatedToAllDelegates() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        XCTAssertFalse(firstDataSource.notifiedScrollViewDidEndDragging)
        XCTAssertFalse(secondDataSource.notifiedScrollViewDidEndDragging)
        
        composition.scrollViewDidEndDragging(tableView, willDecelerate: false)
        
        XCTAssertTrue(firstDataSource.notifiedScrollViewDidEndDragging)
        XCTAssertTrue(secondDataSource.notifiedScrollViewDidEndDragging)
    }
    
    // MARK: Fake mediator
    
    private class FakeTableViewMediator: NSObject, TableViewMediator {
        
        private(set) var tableViewForReusableViewRegistration: UITableView?
        func registerReusableViews(into tableView: UITableView) {
            tableViewForReusableViewRegistration = tableView
        }
        
        var numberOfRows = 0
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
    
}
