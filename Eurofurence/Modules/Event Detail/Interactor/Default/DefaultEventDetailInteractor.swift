//
//  DefaultEventDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

private protocol EventDetailViewModelComponent {
    func describe(to visitor: EventDetailViewModelVisitor)
}

class DefaultEventDetailInteractor: EventDetailInteractor {

    private class ViewModel: EventDetailViewModel, EventObserver {

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

        func eventDidBecomeFavourite(_ event: Event) {
            delegate?.eventFavourited()
        }

        func eventDidBecomeUnfavourite(_ event: Event) {
            delegate?.eventUnfavourited()
        }

        private let components: [EventDetailViewModelComponent]
        private let event: Event
        private let eventsService: EventsService
        private var isFavourite = false

        init(components: [EventDetailViewModelComponent],
             event: Event,
             eventsService: EventsService) {
            self.components = components
            self.event = event
            self.eventsService = eventsService
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
            components.append(ViewModel.GraphicComponent(viewModel: graphicViewModel))
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
        components.append(ViewModel.SummaryComponent(viewModel: summaryViewModel))

        if event.isSponsorOnly {
            components.append(ViewModel.SponsorsOnlyComponent())
        }

        if event.isSuperSponsorOnly {
            components.append(ViewModel.SuperSponsorsOnlyComponent())
        }

        if event.isArtShow {
            components.append(ViewModel.ArtShowComponent())
        }

        if event.isKageEvent {
            components.append(ViewModel.KageComponent())
        }

        if event.isDealersDen {
            components.append(ViewModel.DealersDenComponent())
        }

        if event.isMainStage {
            components.append(ViewModel.MainStageComponent())
        }

        if event.isPhotoshoot {
            components.append(ViewModel.PhotoshootComponent())
        }

        if !event.eventDescription.isEmpty, event.eventDescription != event.abstract {
            let description = self.markdownRenderer.render(event.eventDescription)
            let descriptionViewModel = EventDescriptionViewModel(contents: description)
            components.append(ViewModel.DescriptionComponent(viewModel: descriptionViewModel))
        }

        let viewModel = ViewModel(components: components, event: event, eventsService: self.eventsService)
        completionHandler(viewModel)
    }

}
