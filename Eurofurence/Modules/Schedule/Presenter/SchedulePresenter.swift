//
//  SchedulePresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class SchedulePresenter: ScheduleSceneDelegate, ScheduleViewModelDelegate, ScheduleSearchViewModelDelegate {

    private struct EventComponentBinder {

        func bind(component: ScheduleEventComponent, to event: ScheduleEventViewModelProtocol) {
            component.setEventName(event.title)
            component.setEventStartTime(event.startTime)
            component.setEventEndTime(event.endTime)
            component.setLocation(event.location)
            event.bannerGraphicPNGData.let(component.setBannerGraphicPNGData)

            if event.bannerGraphicPNGData != nil {
                component.showBanner()
            } else {
                component.hideBanner()
            }

            if event.isSponsorOnly {
                component.showSponsorEventIndicator()
            } else {
                component.hideSponsorEventIndicator()
            }

            if event.isSuperSponsorOnly {
                component.showSuperSponsorOnlyEventIndicator()
            } else {
                component.hideSuperSponsorOnlyEventIndicator()
            }

            if event.isFavourite {
                component.showFavouriteEventIndicator()
            } else {
                component.hideFavouriteEventIndicator()
            }

            if event.isArtShow {
                component.showArtShowEventIndicator()
            } else {
                component.hideArtShowEventIndicator()
            }

            if event.isKageEvent {
                component.showKageEventIndicator()
            } else {
                component.hideKageEventIndicator()
            }

            if event.isDealersDenEvent {
                component.showDealersDenEventIndicator()
            } else {
                component.hideDealersDenEventIndicator()
            }

            if event.isMainStageEvent {
                component.showMainStageEventIndicator()
            } else {
                component.hideMainStageEventIndicator()
            }

            if event.isPhotoshootEvent {
                component.showPhotoshootStageEventIndicator()
            } else {
                component.hidePhotoshootStageEventIndicator()
            }
        }

    }

    private struct EventsBinder: ScheduleSceneBinder {

        var viewModels: [ScheduleEventGroupViewModel]
        var scheduleViewModel: ScheduleViewModel?
        var eventBinder: EventComponentBinder

        func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
            let group = viewModels[index]
            header.setEventGroupTitle(group.title)
        }

        func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]
            eventBinder.bind(component: eventComponent, to: event)
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
        var eventBinder: EventComponentBinder

        func bind(_ eventComponent: ScheduleEventComponent, forSearchResultAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]
            eventBinder.bind(component: eventComponent, to: event)
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
    private let eventBinder = EventComponentBinder()
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
        viewModel?.identifierForEvent(at: indexPath).let(delegate.scheduleModuleDidSelectEvent)
    }

    func scheduleSceneDidSelectSearchResult(at indexPath: IndexPath) {
        scene.deselectSearchResult(at: indexPath)
        searchViewModel?.identifierForEvent(at: indexPath).let(delegate.scheduleModuleDidSelectEvent)
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
        let binder = EventsBinder(viewModels: events, scheduleViewModel: viewModel, eventBinder: eventBinder)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        let numberOfItemsPerGroup = results.map { $0.events.count }
        let binder = SearchResultsBinder(viewModels: results, scheduleSearchViewModel: searchViewModel, eventBinder: eventBinder)
        scene.bindSearchResults(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

}
