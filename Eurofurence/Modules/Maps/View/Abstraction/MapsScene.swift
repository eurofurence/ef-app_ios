//
//  MapsScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapsScene {

    func setDelegate(_ delegate: MapsSceneDelegate)
    func setMapsTitle(_ title: String)
    func bind(numberOfMaps: Int, using binder: MapsBinder)

}

protocol MapsSceneDelegate {

    func mapsSceneDidLoad()

}
