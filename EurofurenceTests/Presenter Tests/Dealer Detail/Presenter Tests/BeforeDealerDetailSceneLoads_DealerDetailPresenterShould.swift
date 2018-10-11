//
//  BeforeDealerDetailSceneLoads_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class BeforeDealerDetailSceneLoads_DealerDetailPresenterShould: XCTestCase {

    func testNotBindOntoTheScene() {
        let context = DealerDetailPresenterTestBuilder().build()
        XCTAssertNil(context.scene.boundNumberOfComponents)
    }

}
