//
//  DealersSearchViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol DealersSearchViewModel {

    func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate)
    func updateSearchResults(with query: String)
    func identifierForDealer(at indexPath: IndexPath) -> Dealer.Identifier?

}

protocol DealersSearchViewModelDelegate {

    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String])

}
