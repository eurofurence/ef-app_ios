//
//  MapsViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol MapsViewModel {

    var numberOfMaps: Int { get }
    func mapViewModel(at index: Int) -> MapViewModel
    func identifierForMap(at index: Int) -> MapIdentifier?

}

protocol MapViewModel {

    var mapName: String { get }
    func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void)

}
