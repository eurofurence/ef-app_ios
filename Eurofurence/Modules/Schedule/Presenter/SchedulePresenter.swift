//
//  SchedulePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct SchedulePresenter: ScheduleSceneDelegate, ScheduleInteractorDelegate, ScheduleViewModelDelegate {

    private struct EventsBinder: ScheduleSceneBinder {

        var viewModels: [ScheduleEventGroupViewModel]

        func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
            let group = viewModels[index]
            header.setEventGroupTitle(group.title)
        }

        func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]

            eventComponent.setEventName(event.title)
            eventComponent.setEventStartTime(event.startTime)
            eventComponent.setEventEndTime(event.endTime)
            eventComponent.setLocation(event.location)
        }

    }

    private struct DaysBinder: ScheduleDaysBinder {

        var viewModels: [ScheduleDayViewModel]

        func bind(_ dayComponent: ScheduleDayComponent, forDayAt index: Int) {
            let day = viewModels[index]
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
        viewModel.setDelegate(self)
    }

    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel]) {
        scene.bind(numberOfDays: days.count, using: DaysBinder(viewModels: days))
    }

    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel]) {
        let numberOfItemsPerGroup = events.map { $0.events.count }
        let binder = EventsBinder(viewModels: events)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

}
