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
        let index = dealersService.makeDealersIndex()
        viewModel = ViewModel(index: index)
    }

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    private class ViewModel: DealersViewModel, DealersIndexDelegate {

        private let index: DealersIndex
        private var groups = [DealersGroupViewModel]()

        init(index: DealersIndex) {
            self.index = index
            index.setDelegate(self)
        }

        private var delegate: DealersViewModelDelegate?
        func setDelegate(_ delegate: DealersViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerGroupsDidChange(groups, indexTitles: groups.map({ $0.title }))
        }

        func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup]) {
            groups = alphabetisedGroups.map { (alphabetisedGroup) -> DealersGroupViewModel in
                return DealersGroupViewModel(title: alphabetisedGroup.indexingString, dealers: [])
            }
        }

    }

    private struct DealerVM: DealerViewModel {

        var title: String = ""
        var subtitle: String = ""
        var isPresentForAllDays: Bool = false
        var isAfterDarkContentPresent: Bool = false

        func fetchIconPNGData(completionHandler: @escaping (Data) -> Void) {

        }

    }

}
