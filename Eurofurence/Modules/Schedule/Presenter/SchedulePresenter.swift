import Foundation

class SchedulePresenter: ScheduleSceneDelegate, ScheduleViewModelDelegate, ScheduleSearchViewModelDelegate {

    private class EventComponentBinder: ScheduleEventViewModelObserver {

        private let component: ScheduleEventComponent
        private let viewModel: ScheduleEventViewModelProtocol

        init(component: ScheduleEventComponent, viewModel: ScheduleEventViewModelProtocol) {
            self.component = component
            self.viewModel = viewModel
            
            viewModel.add(self)
        }
        
        func eventViewModelDidBecomeFavourite(_ viewModel: ScheduleEventViewModelProtocol) {
            component.showFavouriteEventIndicator()
        }
        
        func eventViewModelDidBecomeNonFavourite(_ viewModel: ScheduleEventViewModelProtocol) {
            component.hideFavouriteEventIndicator()
        }

        func bind() {
            bindTextualAttributes()
            bindBannerGraphic()
            bindEventIconography()
        }

        private func bindTextualAttributes() {
            component.setEventName(viewModel.title)
            component.setEventStartTime(viewModel.startTime)
            component.setEventEndTime(viewModel.endTime)
            component.setLocation(viewModel.location)
        }

        private func bindBannerGraphic() {
            viewModel.bannerGraphicPNGData.let(component.setBannerGraphicPNGData)

            if viewModel.bannerGraphicPNGData != nil {
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
            if viewModel.isSponsorOnly {
                component.showSponsorEventIndicator()
            } else {
                component.hideSponsorEventIndicator()
            }
        }

        private func bindSuperSponsorOnlyIcon() {
            if viewModel.isSuperSponsorOnly {
                component.showSuperSponsorOnlyEventIndicator()
            } else {
                component.hideSuperSponsorOnlyEventIndicator()
            }
        }

        private func bindFavouriteIcon() {
            if viewModel.isFavourite {
                component.showFavouriteEventIndicator()
            } else {
                component.hideFavouriteEventIndicator()
            }
        }

        private func bindArtShowIcon() {
            if viewModel.isArtShow {
                component.showArtShowEventIndicator()
            } else {
                component.hideArtShowEventIndicator()
            }
        }

        private func bindKageIcon() {
            if viewModel.isKageEvent {
                component.showKageEventIndicator()
            } else {
                component.hideKageEventIndicator()
            }
        }

        private func bindDealersDenIcon() {
            if viewModel.isDealersDenEvent {
                component.showDealersDenEventIndicator()
            } else {
                component.hideDealersDenEventIndicator()
            }
        }

        private func bindMainStageIcon() {
            if viewModel.isMainStageEvent {
                component.showMainStageEventIndicator()
            } else {
                component.hideMainStageEventIndicator()
            }
        }

        private func bindPhotoshootIcon() {
            if viewModel.isPhotoshootEvent {
                component.showPhotoshootStageEventIndicator()
            } else {
                component.hidePhotoshootStageEventIndicator()
            }
        }

    }

    private class EventsBinder: ScheduleSceneBinder {

        private let viewModels: [ScheduleEventGroupViewModel]
        private var eventBinders = [IndexPath: EventComponentBinder]()

        init(viewModels: [ScheduleEventGroupViewModel]) {
            self.viewModels = viewModels
        }

        func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
            let group = viewModels[index]
            header.setEventGroupTitle(group.title)
        }

        func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let eventViewModel = group.events[indexPath.item]
            let binder = EventComponentBinder(component: eventComponent, viewModel: eventViewModel)
            binder.bind()
            
            eventBinders[indexPath] = binder
        }

        func eventActionForComponent(at indexPath: IndexPath) -> ScheduleEventComponentAction {
            let group = viewModels[indexPath.section]
            let event = group.events[indexPath.item]

            if event.isFavourite {
                return ScheduleEventComponentAction(title: .unfavourite, run: event.unfavourite)
            } else {
                return ScheduleEventComponentAction(title: .favourite, run: event.favourite)
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
    private let delegate: ScheduleComponentDelegate
    private let hapticEngine: SelectionChangedHaptic
    private var viewModel: ScheduleViewModel?
    private var searchViewModel: ScheduleSearchViewModel?

    init(scene: ScheduleScene,
         interactor: ScheduleInteractor,
         delegate: ScheduleComponentDelegate,
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
        viewModel?.identifierForEvent(at: indexPath).let(delegate.scheduleComponentDidSelectEvent)
    }

    func scheduleSceneDidSelectSearchResult(at indexPath: IndexPath) {
        scene.deselectSearchResult(at: indexPath)
        searchViewModel?.identifierForEvent(at: indexPath).let(delegate.scheduleComponentDidSelectEvent)
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
        let numberOfItemsPerGroup = events.map(\.events.count)
        let binder = EventsBinder(viewModels: events)
        scene.bind(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        let numberOfItemsPerGroup = results.map(\.events.count)
        let binder = EventsBinder(viewModels: results)
        scene.bindSearchResults(numberOfItemsPerSection: numberOfItemsPerGroup, using: binder)
    }

}
