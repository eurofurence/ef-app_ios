import EurofurenceApplication

struct StubDealersDenEventViewModel: EventDetailViewModel {

    var dealersDenMessageViewModel: EventDealersDenMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(dealersDenMessageViewModel)
    }
    
    func favourite() { }
    func unfavourite() { }

}
