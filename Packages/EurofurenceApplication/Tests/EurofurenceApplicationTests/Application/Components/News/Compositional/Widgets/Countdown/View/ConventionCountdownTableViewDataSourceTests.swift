import Combine
import EurofurenceApplication
import ObservedObject
import UIKit
import XCTest

class ConventionCountdownTableViewDataSourceTests: XCTestCase {
    
    private var viewModel: ControllableConventionCountdownViewModel!
    private var dataSource: ConventionCountdownTableViewDataSource<ControllableConventionCountdownViewModel>!
    private var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        viewModel = ControllableConventionCountdownViewModel()
        let viewFactory = ConventionCountdownViewFactory<ControllableConventionCountdownViewModel>()
        dataSource = viewFactory.makeVisualController(viewModel: viewModel)
        tableView = UITableView()
        dataSource.registerReusableViews(into: tableView)
    }
    
    func testHasOneRowWhenToldToShowCountdown() {
        viewModel.showCountdown = true
        
        XCTAssertEqual(1, dataSource.tableView(tableView, numberOfRowsInSection: 0))
    }
    
    func testHasNoRowsWhenToldToHideCountdown() {
        viewModel.showCountdown = false
        
        XCTAssertEqual(0, dataSource.tableView(tableView, numberOfRowsInSection: 0))
    }
    
    func testShowCountdownChangesSendsSectionChangedUpdate() {
        let delegate = CapturingTableViewMediatorDelegate()
        dataSource.delegate = delegate
        
        XCTAssertFalse(delegate.contentsDidChange)
        
        viewModel.showCountdown = true
        
        XCTAssertTrue(delegate.contentsDidChange)
    }
    
    func testCountdownDescriptionChangesDoesNotSendSectionChangedUpdate() {
        let delegate = CapturingTableViewMediatorDelegate()
        dataSource.delegate = delegate
        
        XCTAssertFalse(delegate.contentsDidChange)
        
        viewModel.countdownDescription = "0 days remaining"
        
        XCTAssertFalse(delegate.contentsDidChange)
    }
    
    func testCountdownCellBindsInitialValue() throws {
        viewModel.showCountdown = true
        viewModel.countdownDescription = "1 day remaining"
        
        let countdownLabel: UILabel = try findBindingTarget("Countdown_DaysRemaining")
        
        XCTAssertEqual("1 day remaining", countdownLabel.text)
    }
    
    func testCountdownCellBindsFutureValues() throws {
        viewModel.showCountdown = true
        let countdownLabel: UILabel = try findBindingTarget("Countdown_DaysRemaining")
        
        viewModel.countdownDescription = "1 day remaining"
        
        XCTAssertEqual("1 day remaining", countdownLabel.text)
    }
    
    private func findBindingTarget<View>(_ accessibilityIdentifier: String) throws -> View where View: UIView {
        let firstRowFirstSection = IndexPath(row: 0, section: 0)
        let cell = dataSource.tableView(tableView, cellForRowAt: firstRowFirstSection)
        let countdownCell = try XCTUnwrap(cell as? NewsConventionCountdownTableViewCell)
        let bindingTarget: View? = countdownCell.viewWithAccessibilityIdentifier(accessibilityIdentifier)
        
        return try XCTUnwrap(bindingTarget)
    }
    
    private class ControllableConventionCountdownViewModel: ConventionCountdownViewModel {
        
        @Observed var showCountdown: Bool = false
        @Observed var countdownDescription: String?
        
    }
    
}
