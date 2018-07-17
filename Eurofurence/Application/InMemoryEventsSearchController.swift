//
//  InMemoryEventsSearchController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class InMemoryEventsSearchController: EventsSearchController {

    private let schedule: Schedule

    init(schedule: Schedule) {
        self.schedule = schedule
    }

    private var delegate: EventsSearchControllerDelegate?
    func setResultsDelegate(_ delegate: EventsSearchControllerDelegate) {
        self.delegate = delegate
    }

    func changeSearchTerm(_ term: String) {
        let matches = schedule.eventModels.filter({ $0.title.localizedCaseInsensitiveContains(term) })
        delegate?.searchResultsDidUpdate(to: matches)
    }

    func restrictResultsToFavourites() {

    }

    func removeFavouritesEventsRestriction() {

    }

}
