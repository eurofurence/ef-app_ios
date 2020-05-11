import Eurofurence

struct StubActionEventViewModel: EventDetailViewModel {
    
    var actionViewModel: EventActionViewModel
    
    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(actionViewModel
        ) }
    func favourite() { }
    func unfavourite() { }
    
}
