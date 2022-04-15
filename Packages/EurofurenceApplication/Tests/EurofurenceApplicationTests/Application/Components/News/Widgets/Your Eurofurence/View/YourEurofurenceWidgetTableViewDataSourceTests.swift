import ComponentBase
import EurofurenceApplication
import ObservedObject
import XCTest

class YourEurofurenceWidgetTableViewDataSourceTests: XCTestCase {
    
    private var viewModel: ControllableYourEurofurenceWidgetViewModel!
    private var dataSource: YourEurofurenceWidgetTableViewDataSource<ControllableYourEurofurenceWidgetViewModel>!
    private var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        viewModel = ControllableYourEurofurenceWidgetViewModel()
        let factory = YourEurofurenceWidgetViewFactory<ControllableYourEurofurenceWidgetViewModel>()
        dataSource = factory.makeVisualController(viewModel: viewModel)
        tableView = UITableView()
        dataSource.registerReusableViews(into: tableView)
    }
    
    func testHasOneRow() {
        XCTAssertEqual(1, dataSource.tableView(tableView, numberOfRowsInSection: 0))
    }
    
    func testHasYourEurofurenceHeader() throws {
        let sectionHeaderView = dataSource.tableView(tableView, viewForHeaderInSection: 0)
        let headerView = try XCTUnwrap(sectionHeaderView as? ConventionBrandedTableViewHeaderFooterView)
        
        XCTAssertEqual(String.yourEurofurence, headerView.textLabel?.text)
    }
    
    func testBindsInitialPrompt() throws {
        viewModel.prompt = "Welcome, Some Guy"
        let promptLabel: UILabel = try findBindingTarget("Personalised_Prompt")
        
        XCTAssertEqual("Welcome, Some Guy", promptLabel.text)
    }
    
    func testBindsInitialSupplementaryPrompt() throws {
        viewModel.supplementaryPrompt = "You have (69) new messages"
        let supplementaryPromptLabel: UILabel = try findBindingTarget("Personalised_SupplementaryPrompt")
        
        XCTAssertEqual("You have (69) new messages", supplementaryPromptLabel.text)
    }
    
    func testBindsInitialHighlightedState_Highlighted() throws {
        viewModel.isHighlightedForAttention = true
        let highlightedUserView: UIView = try findBindingTarget("Personalised_UserHighlightedIcon")
        let normalUserView: UIView = try findBindingTarget("Personalised_UserIcon")
        
        XCTAssertFalse(highlightedUserView.isHidden)
        XCTAssertTrue(normalUserView.isHidden)
    }
    
    func testBindsInitialHighlightedState_NotHighlighted() throws {
        viewModel.isHighlightedForAttention = false
        let highlightedUserView: UIView = try findBindingTarget("Personalised_UserHighlightedIcon")
        let normalUserView: UIView = try findBindingTarget("Personalised_UserIcon")
        
        XCTAssertTrue(highlightedUserView.isHidden)
        XCTAssertFalse(normalUserView.isHidden)
    }
    
    func testBindsUpdatedPrompt() throws {
        let promptLabel: UILabel = try findBindingTarget("Personalised_Prompt")
        viewModel.prompt = "Welcome, Some Guy"
        
        XCTAssertEqual("Welcome, Some Guy", promptLabel.text)
    }
    
    func testBindsUpdatedSupplementaryPrompt() throws {
        let supplementaryPromptLabel: UILabel = try findBindingTarget("Personalised_SupplementaryPrompt")
        viewModel.supplementaryPrompt = "You have (69) new messages"
        
        XCTAssertEqual("You have (69) new messages", supplementaryPromptLabel.text)
    }
    
    func testBindsUpdatedHighlightedState() throws {
        viewModel.isHighlightedForAttention = false
        let cell = dequeueCell()
        let highlightedUserView: UIView = try findBindingTarget(in: cell, "Personalised_UserHighlightedIcon")
        let normalUserView: UIView = try findBindingTarget(in: cell, "Personalised_UserIcon")
        viewModel.isHighlightedForAttention = true
        
        XCTAssertFalse(highlightedUserView.isHidden)
        XCTAssertTrue(normalUserView.isHidden)
    }
    
    func testSelectingCellNotifiesViewModel() throws {
        let firstRowFirstSection = IndexPath(row: 0, section: 0)
        
        XCTAssertFalse(viewModel.didShowPersonalisedContent)
        
        dataSource.tableView(tableView, didSelectRowAt: firstRowFirstSection)
        
        XCTAssertTrue(viewModel.didShowPersonalisedContent)
    }
    
    func testDoesNotRetainBindingsForPreviousCell_BUG() throws {
        viewModel.prompt = "Welcome, Some Guy"
        let first = dequeueCell()
        let second = dequeueCell()
        viewModel.prompt = "Welcome, Some Other Guy"
        
        let firstPromptLabel: UILabel = try findBindingTarget(in: first, "Personalised_Prompt")
        let secondPromptLabel: UILabel = try findBindingTarget(in: second, "Personalised_Prompt")
        
        XCTAssertEqual("Welcome, Some Guy", firstPromptLabel.text)
        XCTAssertEqual("Welcome, Some Other Guy", secondPromptLabel.text)
    }
    
    private func dequeueCell() -> UITableViewCell {
        let firstRowFirstSection = IndexPath(row: 0, section: 0)
        return dataSource.tableView(tableView, cellForRowAt: firstRowFirstSection)
    }
    
    private func findBindingTarget<View>(_ accessibilityIdentifier: String) throws -> View where View: UIView {
        return try findBindingTarget(in: dequeueCell(), accessibilityIdentifier)
    }
    
    private func findBindingTarget<View>(
        in parent: UIView,
        _ accessibilityIdentifier: String
    ) throws -> View where View: UIView {
        let bindingTarget: View? = parent.viewWithAccessibilityIdentifier(accessibilityIdentifier)
        
        return try XCTUnwrap(bindingTarget)
    }
    
    private class ControllableYourEurofurenceWidgetViewModel: YourEurofurenceWidgetViewModel {
        
        @Observed var prompt: String = ""
        @Observed var supplementaryPrompt: String = ""
        @Observed var isHighlightedForAttention: Bool = false
        
        private(set) var didShowPersonalisedContent = false
        func showPersonalisedContent() {
            didShowPersonalisedContent = true
        }
        
    }
    
}
