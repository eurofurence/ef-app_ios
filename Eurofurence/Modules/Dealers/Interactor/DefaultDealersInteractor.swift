//
//  DefaultDealersInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct DefaultDealersInteractor: DealersInteractor {

    private let viewModel: ViewModel

    init() {
        self.init(dealersService: EurofurenceApplication.shared)
    }

    init(dealersService: DealersService) {
        let defaultIcon = #imageLiteral(resourceName: "defaultAvatar")
        let defaultIconData = UIImagePNGRepresentation(defaultIcon)!
        self.init(dealersService: dealersService, defaultIconData: defaultIconData)
    }

    init(dealersService: DealersService, defaultIconData: Data) {
        viewModel = ViewModel(dealersService: dealersService, defaultIconData: defaultIconData)
    }

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void) {

    }

    private class ViewModel: DealersViewModel, DealersIndexDelegate {

        private let index: DealersIndex
        private let dealersService: DealersService
        private let defaultIconData: Data
        private var groups = [DealersGroupViewModel]()

        init(dealersService: DealersService, defaultIconData: Data) {
            self.dealersService = dealersService
            self.defaultIconData = defaultIconData
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
            return DealerVM(dealer: dealer, dealersService: dealersService, defaultIconData: defaultIconData)
        }

    }

    private struct DealerVM: DealerViewModel {

        private let dealer: Dealer2
        private let dealersService: DealersService
        private let defaultIconData: Data

        init(dealer: Dealer2, dealersService: DealersService, defaultIconData: Data) {
            self.dealer = dealer
            self.dealersService = dealersService
            self.defaultIconData = defaultIconData

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
                completionHandler(iconPNGData ?? self.defaultIconData)
            }
        }

    }

}
