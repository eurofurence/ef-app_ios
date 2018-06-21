//
//  DealerDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealerDetailScene {

    func setDelegate(_ delegate: DealerDetailSceneDelegate)
    func bind(numberOfComponents: Int)

}

protocol DealerDetailSceneDelegate {

    func dealerDetailSceneDidLoad()

}
