//
//  CapturingMapsModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingMapsModuleDelegate: MapsModuleDelegate {

    private(set) var capturedMapIdentifierToPresent: Map.Identifier?
    func mapsModuleDidSelectMap(identifier: Map.Identifier) {
        capturedMapIdentifierToPresent = identifier
    }

}
