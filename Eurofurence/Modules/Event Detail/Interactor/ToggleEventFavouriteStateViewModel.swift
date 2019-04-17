import EurofurenceModel

class ToggleEventFavouriteStateViewModel: EventActionViewModel, EventObserver {
    
    private let event: Event
    private var isFavourite = false
    
    init(event: Event) {
        self.event = event
        event.add(self)
    }
    
    func eventDidBecomeFavourite(_ event: Event) {
        isFavourite = true
    }
    
    func eventDidBecomeUnfavourite(_ event: Event) {
        isFavourite = false
    }
    
    private var visitor: EventActionViewModelVisitor?
    func describe(to visitor: EventActionViewModelVisitor) {
        self.visitor = visitor
        visitor.visitActionTitle(.unfavourite)
    }
    
    func perform() {
        if isFavourite {
            event.unfavourite()
        } else {
            event.favourite()
        }
        
        visitor?.visitActionTitle(.favourite)
    }
    
}
