import EventDetailComponent

class CapturingEventActionViewModelVisitor: EventActionViewModelVisitor {
    
    private(set) var actionTitle: String?
    func visitActionTitle(_ actionTitle: String) {
        self.actionTitle = actionTitle
    }
    
}
