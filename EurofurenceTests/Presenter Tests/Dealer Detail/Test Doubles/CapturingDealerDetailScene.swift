//
//  CapturingDealerDetailScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class CapturingDealerDetailScene: UIViewController, DealerDetailScene, DealerDetailComponentFactory {

    private(set) var delegate: DealerDetailSceneDelegate?
    func setDelegate(_ delegate: DealerDetailSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var boundNumberOfComponents: Int?
    private(set) var binder: DealerDetailSceneBinder?
    func bind(numberOfComponents: Int, using binder: DealerDetailSceneBinder) {
        boundNumberOfComponents = numberOfComponents
        self.binder = binder
    }
    
    typealias Component = AnyObject
    
    private(set) var boundDealerSummaryComponent: CapturingDealerDetailSummaryComponent?
    func makeDealerSummaryComponent(configureUsing block: (DealerDetailSummaryComponent) -> Void) -> Component {
        let component = CapturingDealerDetailSummaryComponent()
        block(component)
        boundDealerSummaryComponent = component
        return component
    }
    
}

extension CapturingDealerDetailScene {
    
    @discardableResult
    func bindComponent(at index: Int) -> Component? {
        return binder?.bindComponent(at: index, using: self)
    }
    
}

class CapturingDealerDetailSummaryComponent: DealerDetailSummaryComponent {
    
    private(set) var capturedArtistImagePNGData: Data?
    func showArtistArtworkImageWithPNGData(_ data: Data) {
        capturedArtistImagePNGData = data
    }
    
}
