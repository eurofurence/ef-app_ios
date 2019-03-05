//
//  WhenFetchingEventsBeforeRefreshWhenStoreHasEvents.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 05/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingEventsBeforeRefreshWhenStoreHasEvents: XCTestCase {

    func testTheEventsFromTheStoreAreAdapted() {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = FakeDataStore(response: response)
        let imageRepository = CapturingImageRepository()
        let bannerIdentifiers = response.events.changed.compactMap({ $0.bannerImageId })
        let posterIdentifiers = response.events.changed.compactMap({ $0.posterImageId })
        imageRepository.stub(identifiers: bannerIdentifiers + posterIdentifiers)

        let context = ApplicationTestBuilder().with(dataStore).with(imageRepository).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(observer.allEvents, characterisedBy: response.events.changed)
    }

}
