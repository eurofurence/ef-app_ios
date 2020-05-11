import EurofurenceModel

public struct LeaveFeedbackActionViewModel: EventActionViewModel {
    
    var actionBus: DefaultEventDetailViewModel.ActionBus
    
    public func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.leaveFeedback)
    }
    
    public func perform(sender: Any?) {
        actionBus.leaveFeedbackAction?()
    }
    
}
