import EventDetailComponent

struct StubSuperSponsorsOnlyEventViewModel: EventDetailViewModel {

    var superSponsorsOnlyWarningViewModel: EventSuperSponsorsOnlyWarningViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(superSponsorsOnlyWarningViewModel)
    }
    
    func favourite() { }
    func unfavourite() { }

}
