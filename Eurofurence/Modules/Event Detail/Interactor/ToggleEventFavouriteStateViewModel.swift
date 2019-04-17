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
        
        if isFavourite {
            visitor.visitActionTitle(.unfavourite)
        } else {
            visitor.visitActionTitle(.favourite)
        }
    }
    
    func perform() {
        if isFavourite {
            event.unfavourite()
            visitor?.visitActionTitle(.favourite)
        } else {
            event.favourite()
            visitor?.visitActionTitle(.unfavourite)
        }
    }
    
}
