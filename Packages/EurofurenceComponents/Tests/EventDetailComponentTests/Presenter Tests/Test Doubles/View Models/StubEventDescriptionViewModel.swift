import EventDetailComponent

struct StubEventDescriptionViewModel: EventDetailViewModel {

    var numberOfComponents: Int = .random
    private let eventDescription: EventDescriptionViewModel
    private let expectedIndex: Int

    init(eventDescription: EventDescriptionViewModel, at index: Int) {
        self.eventDescription = eventDescription
        expectedIndex = index
    }

    func setDelegate(_ delegate: EventDetailViewModelDelegate) {

    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(eventDescription.randomized(ifFalse: index == expectedIndex))
    }

    func favourite() {

    }

    func unfavourite() {

    }

}
