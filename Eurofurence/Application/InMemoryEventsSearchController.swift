//
//  InMemoryEventsSearchController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct InMemoryEventsSearchController: EventsSearchController {

    func setResultsDelegate(_ delegate: EventsSearchControllerDelegate) {
        delegate.searchResultsDidUpdate(to: [])
    }

    func changeSearchTerm(_ term: String) {

    }

}
