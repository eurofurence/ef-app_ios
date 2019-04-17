import EurofurenceModel
import Foundation

protocol EventDetailViewModelComponent {
    func describe(to visitor: EventDetailViewModelVisitor)
}

class DefaultEventDetailViewModel: EventDetailViewModel, EventObserver {

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

    init(components: [EventDetailViewModelComponent], event: Event) {
        self.components = components
        self.event = event
    }

    var numberOfComponents: Int {
        return components.count
    }

    private var delegate: EventDetailViewModelDelegate?
    func setDelegate(_ delegate: EventDetailViewModelDelegate) {
        self.delegate = delegate
        event.add(self)
    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        guard index < components.count else { return }
        components[index].describe(to: visitor)
    }

    func favourite() {
        event.favourite()
    }

    func unfavourite() {
        event.unfavourite()
    }

}
