import EurofurenceModel
import Foundation

class DefaultEventDetailInteractor: EventDetailInteractor {

    private let dateRangeFormatter: DateRangeFormatter
    private let eventsService: EventsService
	private let markdownRenderer: MarkdownRenderer

    convenience init() {
        self.init(dateRangeFormatter: FoundationDateRangeFormatter.shared,
                  eventsService: SharedModel.instance.services.events,
				  markdownRenderer: DefaultDownMarkdownRenderer())
    }

	init(dateRangeFormatter: DateRangeFormatter, eventsService: EventsService, markdownRenderer: MarkdownRenderer) {
        self.dateRangeFormatter = dateRangeFormatter
        self.eventsService = eventsService
		self.markdownRenderer = markdownRenderer
    }

    func makeViewModel(for identifier: EventIdentifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        guard let event = eventsService.fetchEvent(identifier: identifier) else { return }

        let viewModel = ViewModelBuilder(dateRangeFormatter: dateRangeFormatter, event: event, markdownRenderer: markdownRenderer).build()
        completionHandler(viewModel)
    }
    
    private class ViewModelBuilder {
        
        private let dateRangeFormatter: DateRangeFormatter
        private let event: Event
        private let markdownRenderer: MarkdownRenderer
        private var components = [EventDetailViewModelComponent]()

        init(dateRangeFormatter: DateRangeFormatter, event: Event, markdownRenderer: MarkdownRenderer) {
            self.dateRangeFormatter = dateRangeFormatter
            self.event = event
            self.markdownRenderer = markdownRenderer
        }
        
        func build() -> DefaultEventDetailViewModel {
            if let graphicData = event.posterGraphicPNGData ?? event.bannerGraphicPNGData {
                let graphicViewModel = EventGraphicViewModel(pngGraphicData: graphicData)
                components.append(DefaultEventDetailViewModel.GraphicComponent(viewModel: graphicViewModel))
            }
            
            let abstract = self.markdownRenderer.render(event.abstract)
            let startEndTimeString = self.dateRangeFormatter.string(from: event.startDate, to: event.endDate)
            let summaryViewModel = EventSummaryViewModel(title: event.title,
                                                         subtitle: event.subtitle,
                                                         abstract: abstract,
                                                         eventStartEndTime: startEndTimeString,
                                                         location: event.room.name,
                                                         trackName: event.track.name,
                                                         eventHosts: event.hosts)
            components.append(DefaultEventDetailViewModel.SummaryComponent(viewModel: summaryViewModel))
            
            let toggleFavouriteStateCommand = ToggleEventFavouriteStateViewModel(event: event)
            let toggleFavouriteStateBanner = DefaultEventDetailViewModel.ActionComponent(actionViewModel: toggleFavouriteStateCommand)
            components.append(toggleFavouriteStateBanner)
            
            if event.isAcceptingFeedback {
                let leaveFeedbackCommand = LeaveFeedbackActionViewModel()
                let leaveFeedbackBanner = DefaultEventDetailViewModel.ActionComponent(actionViewModel: leaveFeedbackCommand)
                components.append(leaveFeedbackBanner)
            }
            
            if event.isSponsorOnly {
                components.append(DefaultEventDetailViewModel.SponsorsOnlyComponent())
            }
            
            if event.isSuperSponsorOnly {
                components.append(DefaultEventDetailViewModel.SuperSponsorsOnlyComponent())
            }
            
            if event.isArtShow {
                components.append(DefaultEventDetailViewModel.ArtShowComponent())
            }
            
            if event.isKageEvent {
                components.append(DefaultEventDetailViewModel.KageComponent())
            }
            
            if event.isDealersDen {
                components.append(DefaultEventDetailViewModel.DealersDenComponent())
            }
            
            if event.isMainStage {
                components.append(DefaultEventDetailViewModel.MainStageComponent())
            }
            
            if event.isPhotoshoot {
                components.append(DefaultEventDetailViewModel.PhotoshootComponent())
            }
            
            if !event.eventDescription.isEmpty, event.eventDescription != event.abstract {
                let description = self.markdownRenderer.render(event.eventDescription)
                let descriptionViewModel = EventDescriptionViewModel(contents: description)
                components.append(DefaultEventDetailViewModel.DescriptionComponent(viewModel: descriptionViewModel))
            }
            
            return DefaultEventDetailViewModel(components: components, event: event)
        }
        
    }

}
