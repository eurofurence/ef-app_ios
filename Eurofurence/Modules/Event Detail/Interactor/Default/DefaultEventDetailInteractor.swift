//
//  DefaultEventDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultEventDetailInteractor: EventDetailInteractor {

    private struct ViewModel: EventDetailViewModel {

        var title: String
        var subtitle: String
        var eventStartEndTime: String
        var location: String
        var trackName: String
        var eventHosts: String

    }

    func makeViewModel(for event: Event2, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        let viewModel = ViewModel(title: event.title,
                                  subtitle: "",
                                  eventStartEndTime: "",
                                  location: "",
                                  trackName: "",
                                  eventHosts: "")
        completionHandler(viewModel)
    }

}
