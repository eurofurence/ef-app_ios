import DealersComponent
import RouterCore

public struct DealersRoute: Route {
    
    private let presentation: DealersPresentation
    
    public init(presentation: DealersPresentation) {
        self.presentation = presentation
    }
    
    public func route(_ content: DealersRouteable) {
        presentation.showDealers()
    }
    
}
