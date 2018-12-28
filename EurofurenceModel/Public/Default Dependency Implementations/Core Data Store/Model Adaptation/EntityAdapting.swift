//
//  EntityAdapting.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EntityAdapting {

    associatedtype AdaptedType

    func asAdaptedType() -> AdaptedType

}
