import ComponentBase
import EurofurenceModel
import Foundation

class EventDetailPresenter: EventDetailSceneDelegate, EventDetailViewModelDelegate {

    private struct Binder: EventDetailBinder {

        var viewModel: EventDetailViewModel

        func bindComponent<T>(
            at indexPath: IndexPath,
            using componentFactory: T
        ) -> T.Component where T: EventDetailItemComponentFactory {
            let visitor = ViewModelVisitor(componentFactory: componentFactory)
            viewModel.describe(componentAt: indexPath.item, to: visitor)

            guard let component = visitor.boundComponent else {
                fatalError("Did not bind component at index path: \(indexPath)")
            }

            return component
        }

    }

    private class ViewModelVisitor<T>: EventDetailViewModelVisitor where T: EventDetailItemComponentFactory {

        private let componentFactory: T
        private(set) var boundComponent: T.Component?

        init(componentFactory: T) {
            self.componentFactory = componentFactory
        }

        func visit(_ viewModel: EventSummaryViewModel) {
            boundComponent = componentFactory.makeEventSummaryComponent { (component) in
                component.setEventTitle(viewModel.title)
                component.setEventSubtitle(viewModel.subtitle)
                component.setEventAbstract(viewModel.abstract)
                component.setEventStartEndTime(viewModel.eventStartEndTime)
                component.setEventLocation(viewModel.location)
                component.setTrackName(viewModel.trackName)
                component.setEventHosts(viewModel.eventHosts)
            }
        }

        func visit(_ viewModel: EventDescriptionViewModel) {
            boundComponent = componentFactory.makeEventDescriptionComponent { (component) in
                component.setEventDescription(viewModel.contents)
            }
        }

        func visit(_ graphic: EventGraphicViewModel) {
            boundComponent = componentFactory.makeEventGraphicComponent { (component) in
                component.setPNGGraphicData(graphic.pngGraphicData)
            }
        }

        func visit(_ sponsorsOnlyMessage: EventSponsorsOnlyWarningViewModel) {
            boundComponent = componentFactory.makeSponsorsOnlyBannerComponent { (component) in
                component.setBannerMessage(sponsorsOnlyMessage.message)
            }
        }

        func visit(_ superSponsorsOnlyMessage: EventSuperSponsorsOnlyWarningViewModel) {
            boundComponent = componentFactory.makeSuperSponsorsOnlyBannerComponent { (component) in
                component.setBannerMessage(superSponsorsOnlyMessage.message)
            }
        }

        func visit(_ artShowMessage: EventArtShowMessageViewModel) {
            boundComponent = componentFactory.makeArtShowBannerComponent { (component) in
                component.setBannerMessage(artShowMessage.message)
            }
        }

        func visit(_ kageMessage: EventKageMessageViewModel) {
            boundComponent = componentFactory.makeKageBannerComponent { (component) in
                component.setBannerMessage(kageMessage.message)
            }
        }

        func visit(_ dealersDenMessage: EventDealersDenMessageViewModel) {
            boundComponent = componentFactory.makeDealersDenBannerComponent { (component) in
                component.setBannerMessage(dealersDenMessage.message)
            }
        }

        func visit(_ mainStageMessage: EventMainStageMessageViewModel) {
            boundComponent = componentFactory.makeMainStageBannerComponent { (component) in
                component.setBannerMessage(mainStageMessage.message)
            }
        }

        func visit(_ photoshootMessage: EventPhotoshootMessageViewModel) {
            boundComponent = componentFactory.makePhotoshootBannerComponent { (component) in
                component.setBannerMessage(photoshootMessage.message)
            }
        }
        
        func visit(_ faceMaskMessage: EventFaceMaskMessageViewModel) {
            boundComponent = componentFactory.makeFaceMaskBannerComponent { (component) in
                component.setBannerMessage(faceMaskMessage.message)
            }
        }
        
        func visit(_ actionViewModel: EventActionViewModel) {
            boundComponent = componentFactory.makeEventActionBannerComponent { (component) in
                actionViewModel.describe(to: ComponentRebindingEventActionVisitor(component: component))
                component.setSelectionHandler { [weak actionViewModel] (sender) in
                    actionViewModel?.perform(sender: sender)
                }
            }
        }

    }
    
    struct ComponentRebindingEventActionVisitor: EventActionViewModelVisitor {
        
        let component: EventActionBannerComponent
        
        func visitActionTitle(_ actionTitle: String) {
            component.setActionTitle(actionTitle)
        }
        
    }

    private weak var scene: EventDetailScene?
    private let eventDetailViewModelFactory: EventDetailViewModelFactory
    private let hapticEngine: SelectionChangedHaptic
    private let event: EventIdentifier
    private let delegate: EventDetailComponentDelegate
    private var viewModel: EventDetailViewModel?
    private let interactionRecorder: EventInteractionRecorder
    private var eventInteraction: Interaction?

    init(scene: EventDetailScene,
         eventDetailViewModelFactory: EventDetailViewModelFactory,
         hapticEngine: SelectionChangedHaptic,
         event: EventIdentifier,
         delegate: EventDetailComponentDelegate,
         interactionRecorder: EventInteractionRecorder) {
        self.scene = scene
        self.eventDetailViewModelFactory = eventDetailViewModelFactory
        self.hapticEngine = hapticEngine
        self.event = event
        self.delegate = delegate
        self.interactionRecorder = interactionRecorder

        scene.setDelegate(self)
    }

    func eventDetailSceneDidLoad() {
        eventInteraction = interactionRecorder.makeInteraction(for: event)
        eventInteraction?.donate()
        eventDetailViewModelFactory.makeViewModel(for: event, completionHandler: eventDetailViewModelReady)
    }
    
    func eventDetailSceneDidAppear() {
        eventInteraction?.activate()
    }
    
    func eventDetailSceneDidDisappear() {
        eventInteraction?.deactivate()
    }

    func eventFavourited() {
        hapticEngine.play()
    }

    func eventUnfavourited() {
        hapticEngine.play()
    }
    
    func leaveFeedback() {
        delegate.eventDetailComponentDidRequestPresentationToLeaveFeedback(for: event)
    }

    private func eventDetailViewModelReady(_ viewModel: EventDetailViewModel) {
        self.viewModel = viewModel

        viewModel.setDelegate(self)
        scene?.bind(numberOfComponents: viewModel.numberOfComponents, using: Binder(viewModel: viewModel))
    }

}
