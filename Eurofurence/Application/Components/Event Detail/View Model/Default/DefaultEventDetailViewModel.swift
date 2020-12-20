import EurofurenceModel
import Foundation

protocol EventDetailViewModelComponent {
    func describe(to visitor: EventDetailViewModelVisitor)
}

class DefaultEventDetailViewModel: EventDetailViewModel, EventObserver {
    
    class ActionBus {
        
        var leaveFeedbackAction: (() -> Void)?
        
    }

    struct SummaryComponent: EventDetailViewModelComponent {

        var viewModel: EventSummaryViewModel

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(viewModel)
        }

    }

    struct GraphicComponent: EventDetailViewModelComponent {

        var viewModel: EventGraphicViewModel

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(viewModel)
        }

    }

    struct DescriptionComponent: EventDetailViewModelComponent {

        var viewModel: EventDescriptionViewModel

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(viewModel)
        }

    }

    struct SponsorsOnlyComponent: EventDetailViewModelComponent {

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(EventSponsorsOnlyWarningViewModel(message: .thisEventIsForSponsorsOnly))
        }

    }

    struct SuperSponsorsOnlyComponent: EventDetailViewModelComponent {

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(EventSuperSponsorsOnlyWarningViewModel(message: .thisEventIsForSuperSponsorsOnly))
        }

    }

    struct ArtShowComponent: EventDetailViewModelComponent {

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(EventArtShowMessageViewModel(message: .artShow))
        }

    }

    struct KageComponent: EventDetailViewModelComponent {

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(EventKageMessageViewModel(message: .kageGuestMessage))
        }

    }

    struct DealersDenComponent: EventDetailViewModelComponent {

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(EventDealersDenMessageViewModel(message: .dealersDen))
        }

    }

    struct MainStageComponent: EventDetailViewModelComponent {

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(EventMainStageMessageViewModel(message: .mainStageEvent))
        }

    }

    struct PhotoshootComponent: EventDetailViewModelComponent {

        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(EventPhotoshootMessageViewModel(message: .photoshoot))
        }

    }
    
    struct ActionComponent: EventDetailViewModelComponent {
        
        let actionViewModel: EventActionViewModel
        
        func describe(to visitor: EventDetailViewModelVisitor) {
            visitor.visit(actionViewModel)
        }
        
    }

    func eventDidBecomeFavourite(_ event: Event) {
        delegate?.eventFavourited()
    }

    func eventDidBecomeUnfavourite(_ event: Event) {
        delegate?.eventUnfavourited()
    }

    private let components: [EventDetailViewModelComponent]
    private let event: Event
    private let actionBus: ActionBus

    init(components: [EventDetailViewModelComponent], event: Event, actionBus: ActionBus) {
        self.components = components
        self.event = event
        self.actionBus = actionBus
        
        actionBus.leaveFeedbackAction = { [weak self] in self?.leaveFeedback() }
        event.add(self)
    }

    var numberOfComponents: Int {
        return components.count
    }

    private weak var delegate: EventDetailViewModelDelegate?
    func setDelegate(_ delegate: EventDetailViewModelDelegate) {
        self.delegate = delegate
    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        guard index < components.count else { return }
        components[index].describe(to: visitor)
    }
    
    private func leaveFeedback() {
        delegate?.leaveFeedback()
    }

}
