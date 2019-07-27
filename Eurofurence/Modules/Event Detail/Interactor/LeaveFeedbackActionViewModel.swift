import EurofurenceModel

struct LeaveFeedbackActionViewModel: EventActionViewModel {
    
    var actionBus: DefaultEventDetailViewModel.ActionBus
    
    func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.leaveFeedback)
    }
    
    func perform(sender: Any?) {
        actionBus.leaveFeedbackAction?()
    }
    
}
