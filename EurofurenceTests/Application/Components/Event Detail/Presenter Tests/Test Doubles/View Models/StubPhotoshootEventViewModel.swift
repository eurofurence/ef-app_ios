import Eurofurence

struct StubPhotoshootEventViewModel: EventDetailViewModel {

    var photoshootMessageViewModel: EventPhotoshootMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(photoshootMessageViewModel)
    }
    
    func favourite() { }
    func unfavourite() { }

}
