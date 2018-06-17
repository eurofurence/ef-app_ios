//
//  EventsSearchController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventsSearchController {

    func setResultsDelegate(_ delegate: EventsSearchControllerDelegate)
    func changeSearchTerm(_ term: String)

}

protocol EventsSearchControllerDelegate {

    func searchResultsDidUpdate(to results: [Event2])

}
