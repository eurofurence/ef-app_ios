//
//  InMemoryEventsSearchController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class InMemoryEventsSearchController: EventsSearchController {

    private class Filter {

        func include(event: Event) -> Bool {
            return true
        }

    }

    private class CompositeFilter: Filter {

        private let filters: [Filter]

        init(filters: Filter ...) {
            self.filters = filters
        }

        override func include(event: Event) -> Bool {
            for filter in filters {
                guard filter.include(event: event) else { return false }
            }

            return true
        }

    }

    private class QueryFilter: Filter {

        var query: String = ""

        override func include(event: Event) -> Bool {
            guard query.isEmpty == false else { return true }
            return event.title.localizedCaseInsensitiveContains(query)
        }

    }

    private class FavouritesFilter: Filter {

        var enabled = false
        private let schedule: Schedule

        init(schedule: Schedule) {
            self.schedule = schedule
        }

        override func include(event: Event) -> Bool {
            guard enabled else { return true }
            return schedule.favouriteEventIdentifiers.contains(event.identifier)
        }

    }

    private class RegenerateResultsWhenEventUnfavourited: EventConsumer {

        private let searchController: InMemoryEventsSearchController

        init(searchController: InMemoryEventsSearchController) {
            self.searchController = searchController
        }

        func consume(event: Schedule.EventUnfavouritedEvent) {
            searchController.regenerateSearchResults()
        }

    }

    private let schedule: Schedule
    private let filters: CompositeFilter
    private let queryFilter: QueryFilter
    private let favouritesFilter: FavouritesFilter

    init(schedule: Schedule, eventBus: EventBus) {
        self.schedule = schedule
        queryFilter = QueryFilter()
        favouritesFilter = FavouritesFilter(schedule: schedule)
        filters = CompositeFilter(filters: queryFilter, favouritesFilter)
        eventBus.subscribe(consumer: RegenerateResultsWhenEventUnfavourited(searchController: self))
    }

    private var delegate: EventsSearchControllerDelegate?
    func setResultsDelegate(_ delegate: EventsSearchControllerDelegate) {
        self.delegate = delegate
    }

    func changeSearchTerm(_ term: String) {
        queryFilter.query = term
        regenerateSearchResults()
    }

    func restrictResultsToFavourites() {
        favouritesFilter.enabled = true
        regenerateSearchResults()
    }

    func removeFavouritesEventsRestriction() {
        favouritesFilter.enabled = false

        if queryFilter.query.isEmpty {
            delegate?.searchResultsDidUpdate(to: [])
        } else {
            regenerateSearchResults()
        }
    }

    private func regenerateSearchResults() {
        var matches = [Event]()
        for event in schedule.eventModels {
            guard filters.include(event: event) else { continue }
            matches.append(event)
        }

        delegate?.searchResultsDidUpdate(to: matches)
    }

}
