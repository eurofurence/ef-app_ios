import Eurofurence

struct StubSponsorsOnlyEventViewModel: EventDetailViewModel {

    var sponsorsOnlyWarningViewModel: EventSponsorsOnlyWarningViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(sponsorsOnlyWarningViewModel)
    }
    
    func favourite() { }
    func unfavourite() { }

}
