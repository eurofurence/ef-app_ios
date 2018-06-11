//
//  DefaultEventDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

private protocol EventDetailViewModelComponent {
    func describe(to visitor: EventDetailViewModelVisitor)
}

class DefaultEventDetailInteractor: EventDetailInteractor {

    private class ViewModel: EventDetailViewModel, EventsServiceObserver {

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

        private let components: [EventDetailViewModelComponent]
        private let event: Event2
        private let eventsService: EventsService

        init(components: [EventDetailViewModelComponent],
             event: Event2,
             eventsService: EventsService) {
            self.components = components
            self.event = event
            self.eventsService = eventsService

            eventsService.add(self)
        }

        var numberOfComponents: Int {
            return components.count
        }

        private var delegate: EventDetailViewModelDelegate?
        func setDelegate(_ delegate: EventDetailViewModelDelegate) {
            self.delegate = delegate
            if event.isFavourite {
                delegate.eventFavourited()
            } else {
                delegate.eventUnfavourited()
            }
        }

        func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
            guard index < components.count else { return }
            components[index].describe(to: visitor)
        }

        func favourite() {
            eventsService.favouriteEvent(identifier: event.identifier)
        }

        func unfavourite() {
            eventsService.unfavouriteEvent(identifier: event.identifier)
        }

        func eurofurenceApplicationDidUpdateEvents(to events: [Event2]) { }
        func eurofurenceApplicationDidUpdateRunningEvents(to events: [Event2]) { }
        func eurofurenceApplicationDidUpdateUpcomingEvents(to events: [Event2]) { }

        func eventsServiceDidResolveFavouriteEvents(_ identifiers: [Event2.Identifier]) {
            if identifiers.contains(event.identifier) {
                delegate?.eventFavourited()
            }
        }

    }

    private let dateRangeFormatter: DateRangeFormatter
    private let eventsService: EventsService

    convenience init() {
        self.init(dateRangeFormatter: FoundationDateRangeFormatter.shared,
                  eventsService: EurofurenceApplication.shared)
    }

    init(dateRangeFormatter: DateRangeFormatter, eventsService: EventsService) {
        self.dateRangeFormatter = dateRangeFormatter
        self.eventsService = eventsService
    }

    func makeViewModel(for event: Event2, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        var components = [EventDetailViewModelComponent]()

        if let graphicData = event.posterGraphicPNGData ?? event.bannerGraphicPNGData {
            let graphicViewModel = EventGraphicViewModel(pngGraphicData: graphicData)
            components.append(ViewModel.GraphicComponent(viewModel: graphicViewModel))
        }

        let startEndTimeString = dateRangeFormatter.string(from: event.startDate, to: event.endDate)
        let summaryViewModel = EventSummaryViewModel(title: event.title,
                                                     subtitle: event.abstract,
                                                     eventStartEndTime: startEndTimeString,
                                                     location: event.room.name,
                                                     trackName: event.track.name,
                                                     eventHosts: event.hosts)
        components.append(ViewModel.SummaryComponent(viewModel: summaryViewModel))

        if !event.eventDescription.isEmpty, event.eventDescription != event.abstract {
            let descriptionViewModel = EventDescriptionViewModel(contents: event.eventDescription)
            components.append(ViewModel.DescriptionComponent(viewModel: descriptionViewModel))
        }

        let viewModel = ViewModel(components: components, event: event, eventsService: eventsService)
        completionHandler(viewModel)
    }

}
