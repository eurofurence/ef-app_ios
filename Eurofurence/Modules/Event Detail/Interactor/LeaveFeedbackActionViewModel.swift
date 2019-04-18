import EurofurenceModel

struct LeaveFeedbackActionViewModel: EventActionViewModel {
    
    func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.leaveFeedback)
    }
    
    func perform() {
        
    }
    
}
