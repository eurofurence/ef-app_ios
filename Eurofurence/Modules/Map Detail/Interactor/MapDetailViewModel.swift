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

    func showContentsAtPosition(x: Float, y: Float, describingTo visitor: MapContentVisitor)

}

protocol MapContentVisitor {

    func visit(_ mapPosition: MapCoordinate)
    func visit(_ content: MapInformationContextualContent)
    func visit(_ dealer: Dealer2.Identifier)
    func visit(_ mapContents: MapContentOptionsViewModel)

}
