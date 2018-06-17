//
//  SchedulePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class SchedulePresenter: ScheduleSceneDelegate, ScheduleViewModelDelegate, ScheduleSearchViewModelDelegate {

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
    private let delegate: ScheduleModuleDelegate
    private var viewModel: ScheduleViewModel?
    private var searchViewModel: ScheduleSearchViewModel?

    init(scene: ScheduleScene, interactor: ScheduleInteractor, delegate: ScheduleModuleDelegate) {
        self.scene = scene
        self.interactor = interactor
        self.delegate = delegate

        scene.setDelegate(self)
    }

    func scheduleSceneDidLoad() {
        interactor.makeViewModel { (viewModel) in
            self.viewModel = viewModel
            viewModel.setDelegate(self)
        }

        interactor.makeSearchViewModel { (viewModel) in
            self.searchViewModel = viewModel
            viewModel.setDelegate(self)
        }
    }

    func scheduleSceneDidSelectDay(at index: Int) {
        viewModel?.showEventsForDay(at: index)
    }

    func scheduleSceneDidSelectEvent(at indexPath: IndexPath) {
        scene.deselectEvent(at: indexPath)

        guard let identifier = viewModel?.identifierForEvent(at: indexPath) else { return }
        delegate.scheduleModuleDidSelectEvent(identifier: identifier)
    }

    func scheduleSceneDidUpdateSearchQuery(_ query: String) {
        searchViewModel?.updateSearchResults(input: query)
    }

    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel]) {
        scene.bind(numberOfDays: days.count, using: DaysBinder(viewModels: days))
    }

    func scheduleViewModelDidUpdateCurrentDayIndex(to index: Int) {
        scene.selectDay(at: index)
    }

    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel]) {
        let numberOfItemsPerGroup = events.map { $0.events.count }
        let binder = EventsBinder(viewModels: events)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        let numberOfItemsPerGroup = results.map { $0.events.count }
        scene.bindSearchResults(numberOfItemsPerSection: numberOfItemsPerGroup)
    }

}
