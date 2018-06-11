//
//  EventDetailInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingEventsService: EventsService {
    
    private var observers = [EventsServiceObserver]()
    func add(_ observer: EventsServiceObserver) {
        observers.append(observer)
    }
    
    fileprivate var favourites = [Event2.Identifier]()
    private(set) var favouritedEventIdentifier: Event2.Identifier?
    func favouriteEvent(identifier: Event2.Identifier) {
        favouritedEventIdentifier = identifier
        favourites.append(identifier)
        observers.forEach { $0.eventsServiceDidResolveFavouriteEvents(favourites) }
    }
    
    private(set) var unfavouritedEventIdentifier: Event2.Identifier?
    func unfavouriteEvent(identifier: Event2.Identifier) {
        unfavouritedEventIdentifier = identifier
        if let idx = favourites.index(of: identifier) {
            favourites.remove(at: idx)
        }
        
        observers.forEach { $0.eventsServiceDidResolveFavouriteEvents([]) }
    }
    
}

extension CapturingEventsService {
    
    func simulateEventFavourited(identifier: Event2.Identifier) {
        favourites.append(identifier)
        observers.forEach { $0.eventsServiceDidResolveFavouriteEvents(favourites) }
    }
    
    func simulateEventUnfavourited(identifier: Event2.Identifier) {
        if let idx = favourites.index(of: identifier) {
            favourites.remove(at: idx)
        }
        
        observers.forEach { $0.eventsServiceDidResolveFavouriteEvents(favourites) }
    }
    
}

class EventDetailInteractorTestBuilder {
    
    struct Context {
        var event: Event2
        var dateRangeFormatter: FakeDateRangeFormatter
        var interactor: DefaultEventDetailInteractor
        var viewModel: EventDetailViewModel?
        var eventsService: CapturingEventsService
    }
    
    func build(for event: Event2 = .random) -> Context {
        let eventsService = CapturingEventsService()
        let dateRangeFormatter = FakeDateRangeFormatter()
        let interactor = DefaultEventDetailInteractor(dateRangeFormatter: dateRangeFormatter, eventsService: eventsService)
        var viewModel: EventDetailViewModel?
        interactor.makeViewModel(for: event) { viewModel = $0 }
        
        return Context(event: event,
                       dateRangeFormatter: dateRangeFormatter,
                       interactor: interactor,
                       viewModel: viewModel,
                       eventsService: eventsService)
    }
    
}

extension EventDetailInteractorTestBuilder.Context {
    
    func makeExpectedEventSummaryViewModel() -> EventSummaryViewModel {
        return EventSummaryViewModel(title: event.title,
                                     subtitle: event.abstract,
                                     eventStartEndTime: dateRangeFormatter.string(from: event.startDate, to: event.endDate),
                                     location: event.room.name,
                                     trackName: event.track.name,
                                     eventHosts: event.hosts)
    }
    
    func makeExpectedEventGraphicViewModel() -> EventGraphicViewModel {
        let data = event.posterGraphicPNGData ?? event.bannerGraphicPNGData
        assert(data != nil, "Event used in test isn't stubbed with image data")
        
        return EventGraphicViewModel(pngGraphicData: data!)
    }
    
    func makeExpectedEventDescriptionViewModel() -> EventDescriptionViewModel {
        return EventDescriptionViewModel(contents: event.eventDescription)
    }
    
}
