import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import TestUtilities
import XCTest

struct StubActionEventViewModel: EventDetailViewModel {
    
    var actionViewModel: EventActionViewModel
    
    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(actionViewModel
        ) }
    func favourite() { }
    func unfavourite() { }
    
}

final class FakeEventActionViewModel: EventActionViewModel {
    
    var title: String
    var performedAction: Bool
    private(set) var capturedActionSender: Any?
    
    init(title: String, performedAction: Bool) {
        self.title = title
        self.performedAction = performedAction
    }
    
    private var actionTraitsDidChangeHandler: ((EventActionViewModel) -> Void)?
    func setActionTraitsDidChangeHandler(_ handler: @escaping (EventActionViewModel) -> Void) {
        actionTraitsDidChangeHandler = handler
    }
    
    private var visitor: EventActionViewModelVisitor?
    func describe(to visitor: EventActionViewModelVisitor) {
        self.visitor = visitor
        visitor.visitActionTitle(title)
    }
    
    func perform(sender: Any?) {
        capturedActionSender = sender
        performedAction = true
    }
    
    func simulateTitleChanged(_ newTitle: String) {
        title = newTitle
        visitor?.visitActionTitle(newTitle)
    }
    
}

extension FakeEventActionViewModel: RandomValueProviding {
    
    static var random: FakeEventActionViewModel {
        return FakeEventActionViewModel(title: .random, performedAction: false)
    }
    
}

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
