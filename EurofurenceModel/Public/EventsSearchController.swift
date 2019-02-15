//
//  EventsSearchController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol EventsSearchController {

    func setResultsDelegate(_ delegate: EventsSearchControllerDelegate)
    func changeSearchTerm(_ term: String)
    func restrictResultsToFavourites()
    func removeFavouritesEventsRestriction()

}

public protocol EventsSearchControllerDelegate {

    func searchResultsDidUpdate(to results: [EventProtocol])

}
