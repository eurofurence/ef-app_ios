//
//  CapturingDealersScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class CapturingDealersScene: UIViewController, DealersScene {
    
    private(set) var delegate: DealersSceneDelegate?
    func setDelegate(_ delegate: DealersSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setDealersTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedDealersPerSectionToBind = [Int]()
    func bind(numberOfDealersPerSection: [Int]) {
        capturedDealersPerSectionToBind = numberOfDealersPerSection
    }
    
}
