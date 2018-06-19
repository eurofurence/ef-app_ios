//
//  DefaultDealersInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultDealersInteractor: DealersInteractor {

    private let viewModel: ViewModel

    init(dealersService: DealersService) {
        viewModel = ViewModel(dealersService: dealersService)
    }

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    private class ViewModel: DealersViewModel, DealersIndexDelegate {

        private let index: DealersIndex
        private let dealersService: DealersService
        private var groups = [DealersGroupViewModel]()

        init(dealersService: DealersService) {
            self.dealersService = dealersService
            self.index = dealersService.makeDealersIndex()

            index.setDelegate(self)
        }

        private var delegate: DealersViewModelDelegate?
        func setDelegate(_ delegate: DealersViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerGroupsDidChange(groups, indexTitles: groups.map({ $0.title }))
        }

        func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup]) {
            groups = alphabetisedGroups.map { (alphabetisedGroup) -> DealersGroupViewModel in
                return DealersGroupViewModel(title: alphabetisedGroup.indexingString,
                                             dealers: alphabetisedGroup.dealers.map(makeDealerViewModel))
            }
        }

        private func makeDealerViewModel(for dealer: Dealer2) -> DealerVM {
            return DealerVM(dealer: dealer, dealersService: dealersService)
        }

    }

    private struct DealerVM: DealerViewModel {

        private let dealer: Dealer2
        private let dealersService: DealersService

        init(dealer: Dealer2, dealersService: DealersService) {
            self.dealer = dealer
            self.dealersService = dealersService

            title = dealer.preferredName
            subtitle = dealer.alternateName
            isPresentForAllDays = dealer.isAttendingOnThursday && dealer.isAttendingOnFriday && dealer.isAttendingOnSaturday
            isAfterDarkContentPresent = dealer.isAfterDark
        }

        var title: String = ""
        var subtitle: String?
        var isPresentForAllDays: Bool = true
        var isAfterDarkContentPresent: Bool = false

        func fetchIconPNGData(completionHandler: @escaping (Data) -> Void) {
            dealersService.fetchIconPNGData(for: dealer.identifier) { (iconPNGData) in
                if let iconPNGData = iconPNGData {
                    completionHandler(iconPNGData)
                }
            }
        }

    }

}
