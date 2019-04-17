import Foundation

class ToggleEventFavouriteStateViewModel: EventActionViewModel {
    
    func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.favourite)
    }
    
    func perform() {
        
    }
    
}
