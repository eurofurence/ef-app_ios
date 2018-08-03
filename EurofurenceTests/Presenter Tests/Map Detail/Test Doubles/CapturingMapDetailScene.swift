//
//  CapturingMapDetailScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class CapturingMapDetailScene: UIViewController, MapDetailScene {
    
    private(set) var delegate: MapDetailSceneDelegate?
    func setDelegate(_ delegate: MapDetailSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedMapImagePNGData: Data?
    func setMapImagePNGData(_ data: Data) {
        capturedMapImagePNGData = data
    }
    
    private(set) var capturedTitle: String?
    func setMapTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedMapPositionToFocus: MapCoordinate?
    func focusMapPosition(_ position: MapCoordinate) {
        capturedMapPositionToFocus = position
    }
    
    private(set) var presentedContextualContext: MapInformationContextualContent?
    func show(contextualContent: MapInformationContextualContent) {
        presentedContextualContext = contextualContent
    }
    
    private(set) var capturedOptionsHeading: String?
    private(set) var capturedOptionsPresentationX: Float?
    private(set) var capturedOptionsPresentationY: Float?
    private(set) var capturedOptionsToShow: [String] = []
    private(set) var mapOptionSelectionHandler: ((Int) -> Void)?
    func showMapOptions(heading: String,
                        options: [String],
                        atX x: Float,
                        y: Float,
                        selectionHandler: @escaping (Int) -> Void) {
        capturedOptionsHeading = heading
        capturedOptionsToShow = options
        capturedOptionsPresentationX = x
        capturedOptionsPresentationY = y
        mapOptionSelectionHandler = selectionHandler
    }
    
}
