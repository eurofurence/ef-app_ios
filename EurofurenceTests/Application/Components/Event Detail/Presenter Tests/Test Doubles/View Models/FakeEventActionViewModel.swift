import Eurofurence
import TestUtilities

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
