//
//  DefaultEventDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

private protocol EventDetailViewModelComponent {
    func describe(to visitor: EventDetailViewModelVisitor)
}

class DefaultEventDetailInteractor: EventDetailInteractor {

    private struct ViewModel: EventDetailViewModel {

        struct SummaryComponent: EventDetailViewModelComponent {

            var viewModel: EventSummaryViewModel

            func describe(to visitor: EventDetailViewModelVisitor) {
                visitor.visit(viewModel)
            }

        }

        var component: EventDetailViewModelComponent

        func describe(to visitor: EventDetailViewModelVisitor) {
            component.describe(to: visitor)
        }

    }

    private let dateRangeFormatter: DateRangeFormatter

    convenience init() {
        self.init(dateRangeFormatter: FoundationDateRangeFormatter.shared)
    }

    init(dateRangeFormatter: DateRangeFormatter) {
        self.dateRangeFormatter = dateRangeFormatter
    }

    func makeViewModel(for event: Event2, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        let startEndTimeString = dateRangeFormatter.string(from: event.startDate, to: event.endDate)
        let summaryViewModel = EventSummaryViewModel(title: event.title,
                                                     subtitle: event.abstract,
                                                     eventStartEndTime: startEndTimeString,
                                                     location: event.room.name,
                                                     trackName: event.track.name,
                                                     eventHosts: event.hosts,
                                                     eventDescription: "")
        let viewModel = ViewModel(component: ViewModel.SummaryComponent(viewModel: summaryViewModel))
        completionHandler(viewModel)
    }

}
