//
//  MapDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

protocol MapDetailInteractor {

    func makeViewModelForMap(identifier: Map.Identifier, completionHandler: @escaping (MapDetailViewModel) -> Void)

}
