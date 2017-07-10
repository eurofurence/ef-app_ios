//
//  ApplicationPresentationAssetsTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ApplicationPresentationAssetsTests: XCTestCase {
    
    func testTheInitialLoadInformationAssetShouldProvideTheInformationIconAsset() {
        XCTAssertEqual(#imageLiteral(resourceName: "tuto01_notificationIcon"),
                       ApplicationPresentationAssets().initialLoadInformationAsset)
    }
    
}
