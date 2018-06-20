//
//  DealersScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersScene {

    func setDelegate(_ delegate: DealersSceneDelegate)
    func setDealersTitle(_ title: String)
    func deselectDealer(at indexPath: IndexPath)
    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder)
    func bindSearchResults(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersSearchResultsBinder)

}

protocol DealersSceneDelegate {

    func dealersSceneDidLoad()
    func dealersSceneDidChangeSearchQuery(to query: String)
    func dealersSceneDidSelectDealer(at indexPath: IndexPath)
    func dealersSceneDidSelectDealerSearchResult(at indexPath: IndexPath)

}
