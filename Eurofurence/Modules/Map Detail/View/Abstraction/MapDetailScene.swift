//
//  MapDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapDetailScene {

    func setDelegate(_ delegate: MapDetailSceneDelegate)
    func setMapImagePNGData(_ data: Data)
    func setMapTitle(_ title: String)
    func focusMapPosition(_ position: MapCoordinate)

}

protocol MapDetailSceneDelegate {

    func mapDetailSceneDidLoad()
    func mapDetailSceneDidTapMap(at position: MapCoordinate)

}

struct MapCoordinate: Equatable {
    var x: Float
    var y: Float
}
