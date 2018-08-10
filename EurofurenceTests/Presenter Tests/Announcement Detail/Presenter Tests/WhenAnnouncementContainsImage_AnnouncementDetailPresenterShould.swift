//
//  WhenAnnouncementContainsImage_AnnouncementDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAnnouncementContainsImage_AnnouncementDetailPresenterShould: XCTestCase {
    
    func testBindTheImageOntoTheScene() {
        let context = AnnouncementDetailPresenterTestBuilder().build()
        context.simulateAnnouncementDetailSceneDidLoad()
        
        XCTAssertEqual(context.announcementViewModel.imagePNGData, context.scene.capturedAnnouncementImagePNGData)
    }
    
}
