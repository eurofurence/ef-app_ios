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
        viewModel = ViewModel()
        dealersService.add(viewModel)
    }

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    private class ViewModel: DealersViewModel, DealersServiceObserver {

        private var groups = [DealersGroupViewModel]()

        private var delegate: DealersViewModelDelegate?
        func setDelegate(_ delegate: DealersViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerGroupsDidChange(groups, indexTitles: [])
        }

        func dealersDidChange(_ dealers: [Dealer2]) {
            let grouped = Dictionary(grouping: dealers, by: { $0.preferredName.first! })
            groups = grouped.map({ (key, _) -> DealersGroupViewModel in
                return DealersGroupViewModel(title: String(key), dealers: [])
            }).sorted(by: { $0.title < $1.title })
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
