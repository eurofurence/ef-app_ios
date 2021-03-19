import EventDetailComponent

struct StubArtShowEventViewModel: EventDetailViewModel {

    var artShowMessageViewModel: EventArtShowMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(artShowMessageViewModel)
    }
    
    func favourite() { }
    func unfavourite() { }

}
