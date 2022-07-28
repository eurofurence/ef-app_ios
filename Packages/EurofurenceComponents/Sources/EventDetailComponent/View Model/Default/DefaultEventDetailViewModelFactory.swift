import ComponentBase
import EurofurenceModel
import Foundation

public class DefaultEventDetailViewModelFactory: EventDetailViewModelFactory {

    private let dateRangeFormatter: DateRangeFormatter
    private let eventsService: ScheduleRepository
	private let markdownRenderer: MarkdownRenderer
    private let shareService: ShareService

    public init(
        dateRangeFormatter: DateRangeFormatter,
        eventsService: ScheduleRepository,
        markdownRenderer: MarkdownRenderer,
        shareService: ShareService
    ) {
        self.dateRangeFormatter = dateRangeFormatter
        self.eventsService = eventsService
		self.markdownRenderer = markdownRenderer
        self.shareService = shareService
    }

    public func makeViewModel(
        for identifier: EventIdentifier,
        completionHandler: @escaping (EventDetailViewModel) -> Void
    ) {
        guard let event = eventsService
            .loadSchedule(tag: "Event Detail")
            .loadEvent(identifier: identifier) else { return }

        let viewModel = ViewModelBuilder(
            dateRangeFormatter: dateRangeFormatter,
            event: event,
            markdownRenderer: markdownRenderer,
            shareService: shareService
        ).build()
        
        completionHandler(viewModel)
    }
    
    private class ViewModelBuilder {
        
        private let dateRangeFormatter: DateRangeFormatter
        private let event: Event
        private let markdownRenderer: MarkdownRenderer
        private let shareService: ShareService
        private var components = [EventDetailViewModelComponent]()
        private let actionBus = DefaultEventDetailViewModel.ActionBus()

        init(dateRangeFormatter: DateRangeFormatter,
             event: Event,
             markdownRenderer: MarkdownRenderer,
             shareService: ShareService) {
            self.dateRangeFormatter = dateRangeFormatter
            self.event = event
            self.markdownRenderer = markdownRenderer
            self.shareService = shareService
        }
        
        func build() -> DefaultEventDetailViewModel {
            buildGraphicComponent()
            buildSummaryComponent()
            buildToggleFavouriteStateCommandComponent()
            buildShareComponent()
            buildLeaveFeedbackComponent()
            buildSupplementaryInformationBannerComponents()
            buildEventDescriptionComponent()
            
            return DefaultEventDetailViewModel(components: components, event: event, actionBus: actionBus)
        }
        
        private func buildGraphicComponent() {
            if let graphicData = event.posterGraphicPNGData ?? event.bannerGraphicPNGData {
                let graphicViewModel = EventGraphicViewModel(pngGraphicData: graphicData)
                components.append(DefaultEventDetailViewModel.GraphicComponent(viewModel: graphicViewModel))
            }
        }
        
        private func buildSummaryComponent() {
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
        }
        
        private func buildToggleFavouriteStateCommandComponent() {
            let toggleFavouriteStateCommand = ToggleEventFavouriteStateViewModel(event: event)
            let toggleFavouriteStateBanner = DefaultEventDetailViewModel.ActionComponent(
                actionViewModel: toggleFavouriteStateCommand
            )
            
            components.append(toggleFavouriteStateBanner)
        }
        
        private func buildShareComponent() {
            let command = ShareEventActionViewModel(event: event, shareService: shareService)
            let banner = DefaultEventDetailViewModel.ActionComponent(actionViewModel: command)
            components.append(banner)
        }
        
        private func buildLeaveFeedbackComponent() {
            if event.isAcceptingFeedback {
                let leaveFeedbackCommand = LeaveFeedbackActionViewModel(actionBus: actionBus)
                let leaveFeedbackBanner = DefaultEventDetailViewModel.ActionComponent(
                    actionViewModel: leaveFeedbackCommand
                )
                
                components.append(leaveFeedbackBanner)
            }
        }
        
        private func buildSupplementaryInformationBannerComponents() {
            buildSponsorsOnlyComponent()
            buildSuperSponsorsOnlyComponent()
            buildArtShowComponent()
            buildKageComponent()
            buildDealersDenComponent()
            buildMainStageComponent()
            buildPhotoshootComponent()
            buildFaceMaskRequiredComponent()
        }
        
        private func buildSponsorsOnlyComponent() {
            if event.isSponsorOnly {
                components.append(DefaultEventDetailViewModel.SponsorsOnlyComponent())
            }
        }
        
        private func buildSuperSponsorsOnlyComponent() {
            if event.isSuperSponsorOnly {
                components.append(DefaultEventDetailViewModel.SuperSponsorsOnlyComponent())
            }
        }
        
        private func buildArtShowComponent() {
            if event.isArtShow {
                components.append(DefaultEventDetailViewModel.ArtShowComponent())
            }
        }
        
        private func buildKageComponent() {
            if event.isKageEvent {
                components.append(DefaultEventDetailViewModel.KageComponent())
            }
        }
        
        private func buildDealersDenComponent() {
            if event.isDealersDen {
                components.append(DefaultEventDetailViewModel.DealersDenComponent())
            }
        }
        
        private func buildMainStageComponent() {
            if event.isMainStage {
                components.append(DefaultEventDetailViewModel.MainStageComponent())
            }
        }
        
        private func buildPhotoshootComponent() {
            if event.isPhotoshoot {
                components.append(DefaultEventDetailViewModel.PhotoshootComponent())
            }
        }
        
        private func buildFaceMaskRequiredComponent() {
            if event.isFaceMaskRequired {
                components.append(DefaultEventDetailViewModel.FaceMaskRequiredComponent())
            }
        }
        
        private func buildEventDescriptionComponent() {
            if !event.eventDescription.isEmpty, event.eventDescription != event.abstract {
                let description = markdownRenderer.render(event.eventDescription)
                let descriptionViewModel = EventDescriptionViewModel(contents: description)
                components.append(DefaultEventDetailViewModel.DescriptionComponent(viewModel: descriptionViewModel))
            }
        }
        
    }

}
