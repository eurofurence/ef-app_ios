//
//  MapDetailViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapDetailViewModel {

    var mapImagePNGData: Data { get }
    var mapName: String { get }

}
