//
//  MapDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol MapDetailInteractor {

    func makeViewModelForMap(identifier: MapIdentifier, completionHandler: @escaping (MapDetailViewModel) -> Void)

}
