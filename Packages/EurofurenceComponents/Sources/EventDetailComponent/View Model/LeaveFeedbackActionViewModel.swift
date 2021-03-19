import Foundation

public class LeaveFeedbackActionViewModel: EventActionViewModel {
    
    private let actionBus: DefaultEventDetailViewModel.ActionBus
    
    init(actionBus: DefaultEventDetailViewModel.ActionBus) {
        self.actionBus = actionBus
    }
    
    public func describe(to visitor: EventActionViewModelVisitor) {
        let title = NSLocalizedString(
            "LeaveFeedback",
            bundle: .module,
            comment: "Title for the command shown in the event detail scene for leaving feedback for an event"
        )
        
        visitor.visitActionTitle(title)
    }
    
    public func perform(sender: Any?) {
        actionBus.leaveFeedbackAction?()
    }
    
}
