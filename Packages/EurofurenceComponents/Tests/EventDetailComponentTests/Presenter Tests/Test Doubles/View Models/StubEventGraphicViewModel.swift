import EventDetailComponent

class StubEventGraphicViewModel: EventDetailViewModel {

    private let graphic: EventGraphicViewModel
    private let expectedIndex: Int

    init(graphic: EventGraphicViewModel, at index: Int) {
        self.graphic = graphic
        expectedIndex = index
    }

    var numberOfComponents: Int = 1

    func setDelegate(_ delegate: EventDetailViewModelDelegate) {

    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(graphic.randomized(ifFalse: index == expectedIndex))
    }

    func favourite() {

    }

    func unfavourite() {

    }

}
