import ComponentBase
import Foundation

public class LeaveFeedbackActionViewModel: EventActionViewModel {
    
    private let actionBus: DefaultEventDetailViewModel.ActionBus
    
    init(actionBus: DefaultEventDetailViewModel.ActionBus) {
        self.actionBus = actionBus
    }
    
    public func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.leaveFeedback)
    }
    
    public func perform(sender: Any?) {
        actionBus.leaveFeedbackAction?()
    }
    
}
