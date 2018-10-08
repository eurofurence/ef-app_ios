//
//  DealersViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

protocol DealersViewModel {

    func setDelegate(_ delegate: DealersViewModelDelegate)
    func identifierForDealer(at indexPath: IndexPath) -> Dealer2.Identifier?
    func refresh()

}

protocol DealersViewModelDelegate {

    func dealersRefreshDidBegin()
    func dealersRefreshDidFinish()
    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String])

}
