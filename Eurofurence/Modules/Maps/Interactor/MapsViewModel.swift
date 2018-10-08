//
//  MapsViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

protocol MapsViewModel {

    var numberOfMaps: Int { get }
    func mapViewModel(at index: Int) -> MapViewModel2
    func identifierForMap(at index: Int) -> Map2.Identifier?

}

protocol MapViewModel2 {

    var mapName: String { get }
    func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void)

}
