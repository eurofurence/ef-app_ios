import EventDetailComponent

struct StubKageEventViewModel: EventDetailViewModel {

    var kageMessageViewModel: EventKageMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(kageMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }

}
