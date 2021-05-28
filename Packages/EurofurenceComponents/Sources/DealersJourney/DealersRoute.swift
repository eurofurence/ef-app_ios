import ComponentBase
import DealersComponent

public struct DealersRoute: ContentRoute {
    
    private let presentation: DealersPresentation
    
    public init(presentation: DealersPresentation) {
        self.presentation = presentation
    }
    
    public func route(_ content: DealersContentRepresentation) {
        presentation.showDealers()
    }
    
}
