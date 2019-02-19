//
//  CapturingEventObserver.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel

class CapturingEventObserver: EventObserver {

    enum FavouriteState {
        case unset
        case favourite
        case notFavourite
    }

    private(set) var eventFavouriteState: FavouriteState = .unset
    func eventDidBecomeFavourite(_ event: Event) {
        eventFavouriteState = .favourite
    }

}
