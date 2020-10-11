import Eurofurence

struct StubMainStageEventViewModel: EventDetailViewModel {

    var mainStageMessageViewModel: EventMainStageMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(mainStageMessageViewModel)
    }
    
    func favourite() { }
    func unfavourite() { }

}
