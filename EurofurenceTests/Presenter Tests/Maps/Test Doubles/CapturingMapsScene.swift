//
//  CapturingMapsScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class CapturingMapsScene: UIViewController, MapsScene {
    
    private(set) var delegate: MapsSceneDelegate?
    func setDelegate(_ delegate: MapsSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setMapsTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var boundNumberOfMaps: Int?
    private(set) var binder: MapsBinder?
    func bind(numberOfMaps: Int, using binder: MapsBinder) {
        boundNumberOfMaps = numberOfMaps
        self.binder = binder
    }
    
}
