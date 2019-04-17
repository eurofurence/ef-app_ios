import EurofurenceModel

class ToggleEventFavouriteStateViewModel: EventActionViewModel {
    
    private let event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.unfavourite)
    }
    
    func perform() {
        event.unfavourite()
    }
    
}
