//
//  SchedulePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct SchedulePresenter: ScheduleSceneDelegate, ScheduleInteractorDelegate {

    private struct EventsBinder: ScheduleSceneBinder {

        var viewModel: ScheduleViewModel

        func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
            let group = viewModel.eventGroups[index]
            header.setEventGroupTitle(group.title)
        }

        func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath) {
            let group = viewModel.eventGroups[indexPath.section]
            let event = group.events[indexPath.item]

            eventComponent.setEventName(event.title)
            eventComponent.setEventStartTime(event.startTime)
            eventComponent.setEventEndTime(event.endTime)
            eventComponent.setLocation(event.location)
        }

    }

    private struct DaysBinder: ScheduleDaysBinder {

        var viewModel: ScheduleViewModel

        func bind(_ dayComponent: ScheduleDayComponent, forDayAt index: Int) {
            let day = viewModel.days[index]
            dayComponent.setDayTitle(day.title)
        }

    }

    private let scene: ScheduleScene
    private let interactor: ScheduleInteractor

    init(scene: ScheduleScene, interactor: ScheduleInteractor) {
        self.scene = scene
        self.interactor = interactor

        scene.setDelegate(self)
    }

    func scheduleSceneDidLoad() {
        interactor.setDelegate(self)
    }

    func scheduleInteractorDidPrepareViewModel(_ viewModel: ScheduleViewModel) {
        scene.bind(numberOfDays: viewModel.days.count, using: DaysBinder(viewModel: viewModel))

        let numberOfItemsPerGroup = viewModel.eventGroups.map { $0.events.count }
        let binder = EventsBinder(viewModel: viewModel)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

}
