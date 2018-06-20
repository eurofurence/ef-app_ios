//
//  DealersScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol DealersScene {

    func setDelegate(_ delegate: DealersSceneDelegate)
    func setDealersTitle(_ title: String)
    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder)

}

protocol DealersSceneDelegate {

    func dealersSceneDidLoad()
    func dealersSceneDidChangeSearchQuery(to query: String)

}
