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
    
    func testDataSourceNotifiesContentsChangedReloadsSection() {
        let dataSource = FakeTableViewMediator()
        dataSource.numberOfRows = 5
        composition.append(dataSource)
        
        dataSource.numberOfRows = 10
        
        XCTAssertEqual(10, tableView.numberOfRows(inSection: 0))
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
        firstDataSource.numberOfRows = 5
        secondDataSource.numberOfRows = 10
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        let (firstHeader, secondHeader) = (UIView(), UIView())
        firstDataSource.stub(firstHeader, asViewForHeaderInSection: 0)
        secondDataSource.stub(secondHeader, asViewForHeaderInSection: 1)
        
        XCTAssertIdentical(firstHeader, composition.tableView(tableView, viewForHeaderInSection: 0))
        XCTAssertIdentical(secondHeader, composition.tableView(tableView, viewForHeaderInSection: 1))
    }
    
    func testViewForHeaderInSectionNilWhenSectionEmpty() {
        let dataSource = FakeTableViewMediator()
        dataSource.numberOfRows = 0
        composition.append(dataSource)
        
        let header = UIView()
        dataSource.stub(header, asViewForHeaderInSection: 0)
        
        XCTAssertNil(composition.tableView(tableView, viewForHeaderInSection: 0))
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
    
    func testHeightForFooterInSectionInferredFromSection() {
        let (firstDataSource, secondDataSource) = (FakeTableViewMediator(), FakeTableViewMediator())
        composition.append(firstDataSource)
        composition.append(secondDataSource)
        
        firstDataSource.stub(10, asHeightForFooterInSection: 0)
        secondDataSource.stub(42, asHeightForFooterInSection: 1)
        
        XCTAssertEqual(10, composition.tableView(tableView, heightForFooterInSection: 0))
        XCTAssertEqual(42, composition.tableView(tableView, heightForFooterInSection: 1))
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
    
}
