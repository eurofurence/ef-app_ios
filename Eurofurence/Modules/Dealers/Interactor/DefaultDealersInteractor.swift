//
//  DefaultDealersInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EventBus
import Foundation
import UIKit

struct DefaultDealersInteractor: DealersInteractor, DealersIndexDelegate {

    private let dealersService: DealersService
    private let defaultIconData: Data
    private let refreshService: RefreshService
    private let viewModel: ViewModel
    private let searchViewModel: SearchViewModel
    private let eventBus = EventBus()

    init() {
        self.init(dealersService: SharedModel.instance.services.dealers)
    }

    init(dealersService: DealersService) {
        let defaultIcon = #imageLiteral(resourceName: "defaultAvatar")
        let defaultIconData = defaultIcon.pngData()!
        self.init(dealersService: dealersService,
                  defaultIconData: defaultIconData,
                  refreshService: SharedModel.instance.services.refresh)
    }

    init(dealersService: DealersService, defaultIconData: Data, refreshService: RefreshService) {
        self.dealersService = dealersService
        self.defaultIconData = defaultIconData
        self.refreshService = refreshService

        let index = dealersService.makeDealersIndex()
        viewModel = ViewModel(eventBus: eventBus, refreshService: refreshService)
        searchViewModel = SearchViewModel(eventBus: eventBus, index: index)

        index.setDelegate(self)
    }

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }

    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup]) {
        let (groups, indexTitles) = makeViewModels(from: alphabetisedGroups)
        eventBus.post(AllDealersChangedEvent(rawGroups: alphabetisedGroups,
                                             alphabetisedGroups: groups,
                                             indexTitles: indexTitles))
    }

    func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup]) {
        let (groups, indexTitles) = makeViewModels(from: searchResults)
        eventBus.post(SearchResultsDidChangeEvent(rawGroups: searchResults,
                                                  alphabetisedGroups: groups,
                                                  indexTitles: indexTitles))
    }

    private func makeViewModels(from alphabetisedGroups: [AlphabetisedDealersGroup]) -> (groups: [DealersGroupViewModel], titles: [String]) {
        let groups = alphabetisedGroups.map { (alphabetisedGroup) -> DealersGroupViewModel in
            return DealersGroupViewModel(title: alphabetisedGroup.indexingString,
                                         dealers: alphabetisedGroup.dealers.map(makeDealerViewModel))
        }

        let indexTitles = alphabetisedGroups.map({ $0.indexingString })

        return (groups: groups, titles: indexTitles)
    }

    private func makeDealerViewModel(for dealer: Dealer) -> DealerVM {
        return DealerVM(dealer: dealer, dealersService: dealersService, defaultIconData: defaultIconData)
    }

    private class AllDealersChangedEvent {

        private(set) var rawGroups: [AlphabetisedDealersGroup]
        private(set) var alphabetisedGroups: [DealersGroupViewModel]
        private(set) var indexTitles: [String]

        init(rawGroups: [AlphabetisedDealersGroup], alphabetisedGroups: [DealersGroupViewModel], indexTitles: [String]) {
            self.rawGroups = rawGroups
            self.alphabetisedGroups = alphabetisedGroups
            self.indexTitles = indexTitles
        }

    }

    private struct SearchResultsDidChangeEvent {

        private(set) var rawGroups: [AlphabetisedDealersGroup]
        private(set) var alphabetisedGroups: [DealersGroupViewModel]
        private(set) var indexTitles: [String]

        init(rawGroups: [AlphabetisedDealersGroup], alphabetisedGroups: [DealersGroupViewModel], indexTitles: [String]) {
            self.rawGroups = rawGroups
            self.alphabetisedGroups = alphabetisedGroups
            self.indexTitles = indexTitles
        }

    }

    private class ViewModel: DealersViewModel, EventConsumer, RefreshServiceObserver {

        private let refreshService: RefreshService
        private var rawGroups = [AlphabetisedDealersGroup]()
        private var groups = [DealersGroupViewModel]()
        private var indexTitles = [String]()

        init(eventBus: EventBus, refreshService: RefreshService) {
            self.refreshService = refreshService

            refreshService.add(self)
            eventBus.subscribe(consumer: self)
        }

        private var delegate: DealersViewModelDelegate?
        func setDelegate(_ delegate: DealersViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerGroupsDidChange(groups, indexTitles: indexTitles)
        }

        func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier? {
            return rawGroups[indexPath.section].dealers[indexPath.item].identifier
        }

        func refresh() {
            refreshService.refreshLocalStore { (_) in }
        }

        func consume(event: AllDealersChangedEvent) {
            rawGroups = event.rawGroups
            groups = event.alphabetisedGroups
            indexTitles = event.indexTitles

            delegate?.dealerGroupsDidChange(groups, indexTitles: indexTitles)
        }

        func refreshServiceDidBeginRefreshing() {
            delegate?.dealersRefreshDidBegin()
        }

        func refreshServiceDidFinishRefreshing() {
            delegate?.dealersRefreshDidFinish()
        }

    }

    private class SearchViewModel: DealersSearchViewModel, EventConsumer {

        private let index: DealersIndex
        private var rawGroups = [AlphabetisedDealersGroup]()
        private var groups = [DealersGroupViewModel]()
        private var indexTitles = [String]()

        init(eventBus: EventBus, index: DealersIndex) {
            self.index = index
            eventBus.subscribe(consumer: self)
        }

        private var delegate: DealersSearchViewModelDelegate?
        func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerSearchResultsDidChange(groups, indexTitles: indexTitles)
        }

        func updateSearchResults(with query: String) {
            index.performSearch(term: query)
        }

        func identifierForDealer(at indexPath: IndexPath) -> DealerIdentifier? {
            return rawGroups[indexPath.section].dealers[indexPath.item].identifier
        }

        func consume(event: SearchResultsDidChangeEvent) {
            rawGroups = event.rawGroups
            groups = event.alphabetisedGroups
            indexTitles = event.indexTitles

            delegate?.dealerSearchResultsDidChange(groups, indexTitles: indexTitles)
        }

    }

    private struct DealerVM: DealerViewModel {

        private let dealer: Dealer
        private let dealersService: DealersService
        private let defaultIconData: Data

        init(dealer: Dealer, dealersService: DealersService, defaultIconData: Data) {
            self.dealer = dealer
            self.dealersService = dealersService
            self.defaultIconData = defaultIconData

            title = dealer.preferredName
            subtitle = dealer.alternateName
            isPresentForAllDays = dealer.isAttendingOnThursday && dealer.isAttendingOnFriday && dealer.isAttendingOnSaturday
            isAfterDarkContentPresent = dealer.isAfterDark
        }

        var title: String
        var subtitle: String?
        var isPresentForAllDays: Bool = true
        var isAfterDarkContentPresent: Bool = false

        func fetchIconPNGData(completionHandler: @escaping (Data) -> Void) {
            dealer.fetchIconPNGData { (iconPNGData) in
                completionHandler(iconPNGData ?? self.defaultIconData)
            }
        }

    }

}
