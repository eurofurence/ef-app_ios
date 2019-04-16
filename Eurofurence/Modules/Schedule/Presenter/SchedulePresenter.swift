import Foundation

class SchedulePresenter: ScheduleSceneDelegate, ScheduleViewModelDelegate, ScheduleSearchViewModelDelegate {

    private struct EventComponentBinder {

        var component: ScheduleEventComponent
        var event: ScheduleEventViewModelProtocol

        func bind() {
            bindTextualAttributes()
            bindBannerGraphic()
            bindEventIconography()
        }

        private func bindTextualAttributes() {
            component.setEventName(event.title)
            component.setEventStartTime(event.startTime)
            component.setEventEndTime(event.endTime)
            component.setLocation(event.location)
        }

        private func bindBannerGraphic() {
            event.bannerGraphicPNGData.let(component.setBannerGraphicPNGData)

            if event.bannerGraphicPNGData != nil {
                component.showBanner()
            } else {
                component.hideBanner()
            }
        }

        private func bindEventIconography() {
            bindSponsorOnlyIcon()
            bindSuperSponsorOnlyIcon()
            bindFavouriteIcon()
            bindArtShowIcon()
            bindKageIcon()
            bindDealersDenIcon()
            bindMainStageIcon()
            bindPhotoshootIcon()
        }

        private func bindSponsorOnlyIcon() {
            if event.isSponsorOnly {
                component.showSponsorEventIndicator()
            } else {
                component.hideSponsorEventIndicator()
            }
        }

        private func bindSuperSponsorOnlyIcon() {
            if event.isSuperSponsorOnly {
                component.showSuperSponsorOnlyEventIndicator()
            } else {
                component.hideSuperSponsorOnlyEventIndicator()
            }
        }

        private func bindFavouriteIcon() {
            if event.isFavourite {
                component.showFavouriteEventIndicator()
            } else {
                component.hideFavouriteEventIndicator()
            }
        }

        private func bindArtShowIcon() {
            if event.isArtShow {
                component.showArtShowEventIndicator()
            } else {
                component.hideArtShowEventIndicator()
            }
        }

        private func bindKageIcon() {
            if event.isKageEvent {
                component.showKageEventIndicator()
            } else {
                component.hideKageEventIndicator()
            }
        }

        private func bindDealersDenIcon() {
            if event.isDealersDenEvent {
                component.showDealersDenEventIndicator()
            } else {
                component.hideDealersDenEventIndicator()
            }
        }

        private func bindMainStageIcon() {
            if event.isMainStageEvent {
                component.showMainStageEventIndicator()
            } else {
                component.hideMainStageEventIndicator()
            }
        }

        private func bindPhotoshootIcon() {
            if event.isPhotoshootEvent {
                component.showPhotoshootStageEventIndicator()
            } else {
                component.hidePhotoshootStageEventIndicator()
            }
        }

    }

    private struct EventsBinder: ScheduleSceneBinder {

        var viewModels: [ScheduleEventGroupViewModel]
        var favouriteHandler: (IndexPath) -> Void
        var unfavouriteHandler: (IndexPath) -> Void

        func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
            let group = viewModels[index]
            header.setEventGroupTitle(group.title)
        }

        func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]
            EventComponentBinder(component: eventComponent, event: event).bind()
        }

        func eventActionForComponent(at indexPath: IndexPath) -> ScheduleEventComponentAction {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]

            if event.isFavourite {
                return ScheduleEventComponentAction(title: .unfavourite, run: {
                    self.unfavouriteHandler(indexPath)
                })
            } else {
                return ScheduleEventComponentAction(title: .favourite, run: {
                    self.favouriteHandler(indexPath)
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

    private let scene: ScheduleScene
    private let interactor: ScheduleInteractor
    private let delegate: ScheduleModuleDelegate
    private let hapticEngine: SelectionChangedHaptic
    private var viewModel: ScheduleViewModel?
    private var searchViewModel: ScheduleSearchViewModel?

    init(scene: ScheduleScene,
         interactor: ScheduleInteractor,
         delegate: ScheduleModuleDelegate,
         hapticEngine: SelectionChangedHaptic) {
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
        hapticEngine.play()
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
        guard let viewModel = viewModel else { return }
        
        let numberOfItemsPerGroup = events.map { $0.events.count }
        let binder = EventsBinder(viewModels: events,
                                  favouriteHandler: viewModel.favouriteEvent,
                                  unfavouriteHandler: viewModel.unfavouriteEvent)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        guard let searchViewModel = searchViewModel else { return }
        
        let numberOfItemsPerGroup = results.map { $0.events.count }
        let binder = EventsBinder(viewModels: results,
                                  favouriteHandler: searchViewModel.favouriteEvent,
                                  unfavouriteHandler: searchViewModel.unfavouriteEvent)
        scene.bindSearchResults(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

}
