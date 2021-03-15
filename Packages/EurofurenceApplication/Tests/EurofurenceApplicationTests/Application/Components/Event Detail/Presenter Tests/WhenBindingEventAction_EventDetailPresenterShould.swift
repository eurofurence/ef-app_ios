import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import TestUtilities
import XCTest

class WhenBindingEventAction_EventDetailPresenterShould: XCTestCase {
    
    var actionViewModel: FakeEventActionViewModel!
    var stubbedActionComponent: CapturingEventActionBannerComponent!
    
    override func setUp() {
        super.setUp()
        
        actionViewModel = FakeEventActionViewModel.random
        let viewModel = StubActionEventViewModel(actionViewModel: actionViewModel)
        let event = FakeEvent.random
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        stubbedActionComponent = context.scene.stubbedActionComponent
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
    }

    func testBindTheActionText() {
        XCTAssertEqual(actionViewModel.title, stubbedActionComponent.capturedTitle)
    }
    
    func testInvokeTheActionWhenBannerSelected() {
        let sender = self
        stubbedActionComponent.simulateSelected(sender)
        
        XCTAssertTrue(actionViewModel.performedAction)
        XCTAssertTrue(sender === (actionViewModel.capturedActionSender as AnyObject))
    }
    
    func testUpdateTheTextWhenTheActionChanges() {
        let newTitle = String.random
        actionViewModel.simulateTitleChanged(newTitle)
        
        XCTAssertEqual(newTitle, stubbedActionComponent.capturedTitle)
    }

}
