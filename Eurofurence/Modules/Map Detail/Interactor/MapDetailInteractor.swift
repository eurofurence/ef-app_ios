//
//  MapDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapDetailInteractor {

    func makeViewModelForMap(identifier: Map2.Identifier, completionHandler: @escaping (MapDetailViewModel) -> Void)

}
