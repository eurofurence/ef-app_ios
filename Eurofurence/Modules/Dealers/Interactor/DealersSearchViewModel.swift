//
//  DealersSearchViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersSearchViewModel {

    func searchSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate)
    func updateSearchResults(with query: String)

}

protocol DealersSearchViewModelDelegate {

    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String])

}
