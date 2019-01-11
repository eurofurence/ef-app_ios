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

    static func makeIdentifyingPredicate(for model: AdaptedType) -> NSPredicate
    func asAdaptedType() -> AdaptedType
    func consumeAttributes(from value: AdaptedType)

}
