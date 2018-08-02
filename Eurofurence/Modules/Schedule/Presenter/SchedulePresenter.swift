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
        var scheduleViewModel: ScheduleViewModel?

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

            if event.isSponsorOnly {
                eventComponent.showSponsorEventIndicator()
            } else {
                eventComponent.hideSponsorEventIndicator()
            }

            if event.isSuperSponsorOnly {
                eventComponent.showSuperSponsorOnlyEventIndicator()
            } else {
                eventComponent.hideSuperSponsorOnlyEventIndicator()
            }

            if event.isFavourite {
                eventComponent.showFavouriteEventIndicator()
            } else {
                eventComponent.hideFavouriteEventIndicator()
            }
        }

        func eventActionForComponent(at indexPath: IndexPath) -> ScheduleEventComponentAction {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]

            if event.isFavourite {
                return ScheduleEventComponentAction(title: .unfavourite, run: {
                    self.scheduleViewModel?.unfavouriteEvent(at: indexPath)
                })
            } else {
                return ScheduleEventComponentAction(title: .favourite, run: {
                    self.scheduleViewModel?.favouriteEvent(at: indexPath)
                })
            }
        }

    }

    private struct DaysBinder: ScheduleDaysBinder {

        var viewModels: [ScheduleDayViewModel]

        func bind(_ dayComponent: ScheduleDayComponent, forDayAt index: Int) {
            let day = viewModels[index]
            dayComponent.setDayTitle(day.title)
        }

    }

    private struct SearchResultsBinder: ScheduleSceneSearchResultsBinder {

        var viewModels: [ScheduleEventGroupViewModel]
        var scheduleSearchViewModel: ScheduleSearchViewModel?

        func bind(_ eventComponent: ScheduleEventComponent, forSearchResultAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]

            eventComponent.setEventName(event.title)
            eventComponent.setEventStartTime(event.startTime)
            eventComponent.setEventEndTime(event.endTime)
            eventComponent.setLocation(event.location)

            if event.isSuperSponsorOnly {
                eventComponent.showSuperSponsorOnlyEventIndicator()
            } else {
                eventComponent.hideSuperSponsorOnlyEventIndicator()
            }

            if event.isFavourite {
                eventComponent.showFavouriteEventIndicator()
            } else {
                eventComponent.hideFavouriteEventIndicator()
            }
        }

        func bind(_ header: ScheduleEventGroupHeader, forSearchResultGroupAt index: Int) {
            let group = viewModels[index]
            header.setEventGroupTitle(group.title)
        }

        func eventActionForComponent(at indexPath: IndexPath) -> ScheduleEventComponentAction {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]

            if event.isFavourite {
                return ScheduleEventComponentAction(title: .unfavourite, run: {
                    self.scheduleSearchViewModel?.unfavouriteEvent(at: indexPath)
                })
            } else {
                return ScheduleEventComponentAction(title: .favourite, run: {
                    self.scheduleSearchViewModel?.favouriteEvent(at: indexPath)
                })
            }
        }

    }

    private let scene: ScheduleScene
    private let interactor: ScheduleInteractor
    private let delegate: ScheduleModuleDelegate
    private let hapticEngine: HapticEngine
    private var viewModel: ScheduleViewModel?
    private var searchViewModel: ScheduleSearchViewModel?

    init(scene: ScheduleScene,
         interactor: ScheduleInteractor,
         delegate: ScheduleModuleDelegate,
         hapticEngine: HapticEngine) {
        self.scene = scene
        self.interactor = interactor
        self.delegate = delegate
        self.hapticEngine = hapticEngine

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

    func scheduleSceneDidPerformRefreshAction() {
        viewModel?.refresh()
    }

    func scheduleSceneDidSelectDay(at index: Int) {
        viewModel?.showEventsForDay(at: index)
        hapticEngine.playSelectionHaptic()
    }

    func scheduleSceneDidSelectEvent(at indexPath: IndexPath) {
        scene.deselectEvent(at: indexPath)

        guard let identifier = viewModel?.identifierForEvent(at: indexPath) else { return }
        delegate.scheduleModuleDidSelectEvent(identifier: identifier)
    }

    func scheduleSceneDidSelectSearchResult(at indexPath: IndexPath) {
        scene.deselectSearchResult(at: indexPath)

        guard let identifier = searchViewModel?.identifierForEvent(at: indexPath) else { return }
        delegate.scheduleModuleDidSelectEvent(identifier: identifier)
    }

    private var currentSearchQuery: String = ""
    func scheduleSceneDidUpdateSearchQuery(_ query: String) {
        currentSearchQuery = query
        searchViewModel?.updateSearchResults(input: query)

        if isShowingFavourites {
            scene.showSearchResults()
        }
    }

    func scheduleSceneDidChangeSearchScopeToAllEvents() {
        isShowingFavourites = false
        searchViewModel?.filterToAllEvents()

        if currentSearchQuery.isEmpty {
            scene.hideSearchResults()
        }
    }

    private var isShowingFavourites = false
    func scheduleSceneDidChangeSearchScopeToFavouriteEvents() {
        searchViewModel?.filterToFavourites()
        scene.showSearchResults()
        isShowingFavourites = true
    }

    func scheduleSelectDidSelectFavouritesOption() {
        viewModel?.onlyShowFavourites()
    }

    func scheduleSelectDidSelectAllEventsOption() {
        viewModel?.showAllEvents()
    }

    func scheduleViewModelDidBeginRefreshing() {
        scene.showRefreshIndicator()
    }

    func scheduleViewModelDidFinishRefreshing() {
        scene.hideRefreshIndicator()
    }

    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel]) {
        scene.bind(numberOfDays: days.count, using: DaysBinder(viewModels: days))
    }

    func scheduleViewModelDidUpdateCurrentDayIndex(to index: Int) {
        scene.selectDay(at: index)
    }

    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel]) {
        let numberOfItemsPerGroup = events.map { $0.events.count }
        let binder = EventsBinder(viewModels: events, scheduleViewModel: viewModel)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        let numberOfItemsPerGroup = results.map { $0.events.count }
        let binder = SearchResultsBinder(viewModels: results, scheduleSearchViewModel: searchViewModel)
        scene.bindSearchResults(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

}
