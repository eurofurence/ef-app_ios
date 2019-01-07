//
//  CapturingMapContentVisitor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingMapContentVisitor: MapContentVisitor {

    private(set) var capturedMapCoordinate: MapCoordinate?
    func visit(_ mapPosition: MapCoordinate) {
        capturedMapCoordinate = mapPosition
    }

    private(set) var capturedContextualContent: MapInformationContextualContent?
    func visit(_ content: MapInformationContextualContent) {
        capturedContextualContent = content
    }

    private(set) var capturedDealer: DealerIdentifier?
    func visit(_ dealer: DealerIdentifier) {
        capturedDealer = dealer
    }

    private(set) var capturedMapContents: MapContentOptionsViewModel?
    func visit(_ mapContents: MapContentOptionsViewModel) {
        capturedMapContents = mapContents
    }

}
