//
//  CollectThemAllScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol CollectThemAllScene {

    func setDelegate(_ delegate: CollectThemAllSceneDelegate)
    func setShortCollectThemAllTitle(_ shortTitle: String)
    func setCollectThemAllTitle(_ title: String)
    func loadGame(at urlRequest: URLRequest)

}

protocol CollectThemAllSceneDelegate {

    func collectThemAllSceneDidLoad()

}
