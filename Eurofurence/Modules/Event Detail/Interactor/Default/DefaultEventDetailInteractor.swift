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

        struct DescriptionComponent: EventDetailViewModelComponent {

            var viewModel: EventDescriptionViewModel

            func describe(to visitor: EventDetailViewModelVisitor) {
                visitor.visit(viewModel)
            }

        }

        private let components: [EventDetailViewModelComponent]

        init(components: [EventDetailViewModelComponent]) {
            self.components = components
        }

        var numberOfComponents: Int {
            return components.count
        }

        func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
            components[index].describe(to: visitor)
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
        var components = [EventDetailViewModelComponent]()

        let startEndTimeString = dateRangeFormatter.string(from: event.startDate, to: event.endDate)
        let summaryViewModel = EventSummaryViewModel(title: event.title,
                                                     subtitle: event.abstract,
                                                     eventStartEndTime: startEndTimeString,
                                                     location: event.room.name,
                                                     trackName: event.track.name,
                                                     eventHosts: event.hosts)
        components.append(ViewModel.SummaryComponent(viewModel: summaryViewModel))

        if !event.eventDescription.isEmpty, event.eventDescription != event.abstract {
            let descriptionViewModel = EventDescriptionViewModel(contents: event.eventDescription)
            components.append(ViewModel.DescriptionComponent(viewModel: descriptionViewModel))
        }

        let viewModel = ViewModel(components: components)
        completionHandler(viewModel)
    }

}
