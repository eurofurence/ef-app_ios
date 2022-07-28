import EventDetailComponent

class CapturingEventDetailViewModelVisitor: EventDetailViewModelVisitor {
    
    private var visitedViewModels = [Any]()
    
    private(set) var visitedEventSummary: EventSummaryViewModel?
    func visit(_ summary: EventSummaryViewModel) {
        visitedViewModels.append(summary)
    }
    
    func visit(_ description: EventDescriptionViewModel) {
        visitedViewModels.append(description)
    }
    
    func visit(_ graphic: EventGraphicViewModel) {
        visitedViewModels.append(graphic)
    }
    
    func visit(_ sponsorsOnlyMessage: EventSponsorsOnlyWarningViewModel) {
        visitedViewModels.append(sponsorsOnlyMessage)
    }
    
    func visit(_ superSponsorsOnlyMessage: EventSuperSponsorsOnlyWarningViewModel) {
        visitedViewModels.append(superSponsorsOnlyMessage)
    }
    
    func visit(_ artShowMessage: EventArtShowMessageViewModel) {
        visitedViewModels.append(artShowMessage)
    }
    
    func visit(_ kageMessage: EventKageMessageViewModel) {
        visitedViewModels.append(kageMessage)
    }
    
    func visit(_ dealersDenMessage: EventDealersDenMessageViewModel) {
        visitedViewModels.append(dealersDenMessage)
    }
    
    func visit(_ mainStageMessage: EventMainStageMessageViewModel) {
        visitedViewModels.append(mainStageMessage)
    }
    
    func visit(_ photoshootMessage: EventPhotoshootMessageViewModel) {
        visitedViewModels.append(photoshootMessage)
    }
    
    func visit(_ faceMaskMessage: EventFaceMaskMessageViewModel) {
        visitedViewModels.append(faceMaskMessage)
    }
    
    func visit(_ actionViewModel: EventActionViewModel) {
        visitedViewModels.append(actionViewModel)
    }
    
    func visited<T>(ofKind kind: T.Type) -> T? {
        return visitedViewModels.first(where: { $0 is T }) as? T
    }
    
    func index<T>(of viewModelType: T.Type) -> Int? {
        return visitedViewModels.firstIndex(where: { $0 is T })
    }
    
    func does<A, B>(_ viewModel: A.Type, precede otherViewModel: B.Type) -> Bool {
        guard let first = index(of: viewModel), let second = index(of: otherViewModel) else { return false }
        return first < second
    }
    
    func consume(contentsOf viewModel: EventDetailViewModel) {
        for index in 0...viewModel.numberOfComponents {
            viewModel.describe(componentAt: index, to: self)
        }
    }
    
}
