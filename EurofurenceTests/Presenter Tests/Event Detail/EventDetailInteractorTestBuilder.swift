//
//  EventDetailInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class EventDetailInteractorTestBuilder {
    
    struct Context {
        var event: Event2
        var dateRangeFormatter: FakeDateRangeFormatter
        var interactor: DefaultEventDetailInteractor
        var viewModel: EventDetailViewModel?
    }
    
    func build(for event: Event2 = .random) -> Context {
        let dateRangeFormatter = FakeDateRangeFormatter()
        let interactor = DefaultEventDetailInteractor(dateRangeFormatter: dateRangeFormatter)
        var viewModel: EventDetailViewModel?
        interactor.makeViewModel(for: event) { viewModel = $0 }
        
        return Context(event: event,
                       dateRangeFormatter: dateRangeFormatter,
                       interactor: interactor,
                       viewModel: viewModel)
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
    
    func makeExpectedEventDescriptionViewModel() -> EventDescriptionViewModel {
        return EventDescriptionViewModel(contents: event.eventDescription)
    }
    
}
