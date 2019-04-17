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

        var components = [EventDetailViewModelComponent]()

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
        components.append(DefaultEventDetailViewModel.ActionComponent(actionViewModel: ToggleEventFavouriteStateViewModel()))

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

        let viewModel = DefaultEventDetailViewModel(components: components, event: event)
        completionHandler(viewModel)
    }

}
