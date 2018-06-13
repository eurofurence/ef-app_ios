//
//  CapturingScheduleScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class CapturingScheduleScene: UIViewController, ScheduleScene {
    
    private(set) var delegate: ScheduleSceneDelegate?
    func setDelegate(_ delegate: ScheduleSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setScheduleTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var boundItemsPerSection: [Int] = []
    private(set) var binder: ScheduleSceneBinder?
    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder) {
        boundItemsPerSection = numberOfItemsPerSection
        self.binder = binder
    }
    
}
