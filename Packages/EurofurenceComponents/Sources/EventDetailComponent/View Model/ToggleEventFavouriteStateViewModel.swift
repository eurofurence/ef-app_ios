import EurofurenceModel

public class ToggleEventFavouriteStateViewModel: EventActionViewModel {
    
    private var stateMachine: StateMachine
    
    init(event: Event) {
        stateMachine = StateMachine(event: event)
    }
    
    private var visitor: EventActionViewModelVisitor?
    public func describe(to visitor: EventActionViewModelVisitor) {
        stateMachine.describeCurrentState(to: visitor)
    }
    
    public func perform(sender: Any?) {
        stateMachine.perform()
    }
    
    private class StateMachine: EventObserver {
        
        private var state: State {
            didSet {
                relayCurrentStateToVisitor()
            }
        }
        
        private var visitor: EventActionViewModelVisitor?
        
        init(event: Event) {
            state = UnfavouriteState(event: event)
            event.add(self)
        }
        
        func eventDidBecomeFavourite(_ event: Event) {
            state = FavouriteState(event: event)
        }
        
        func eventDidBecomeUnfavourite(_ event: Event) {
            state = UnfavouriteState(event: event)
        }
        
        func perform() {
            state.perform()
        }
        
        func describeCurrentState(to visitor: EventActionViewModelVisitor) {
            self.visitor = visitor
            state.describe(to: visitor)
        }
        
        private func relayCurrentStateToVisitor() {
            if let visitor = visitor {
                describeCurrentState(to: visitor)
            }
        }
        
    }
    
    private class State {
        
        let event: Event
        private(set) var visitor: EventActionViewModelVisitor?
        
        init(event: Event) {
            self.event = event
        }
        
        func perform() {
            
        }
        
        func describe(to visitor: EventActionViewModelVisitor) {
            self.visitor = visitor
        }
        
    }
    
    private class FavouriteState: State {
        
        override func perform() {
            event.unfavourite()
            visitor?.visitActionTitle(.favourite)
        }
        
        override func describe(to visitor: EventActionViewModelVisitor) {
            super.describe(to: visitor)
            visitor.visitActionTitle(.unfavourite)
        }
        
    }
    
    private class UnfavouriteState: State {
        
        override func perform() {
            event.favourite()
            visitor?.visitActionTitle(.unfavourite)
        }
        
        override func describe(to visitor: EventActionViewModelVisitor) {
            super.describe(to: visitor)
            visitor.visitActionTitle(.favourite)
        }
        
    }
    
}
