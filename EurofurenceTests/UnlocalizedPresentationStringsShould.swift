//
//  UnlocalizedPresentationStringsShould.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class UnlocalizedPresentationStringsShould: XCTestCase {

    private func string(for scenario: PresentationScenario) -> String? {
        return UnlocalizedPresentationStrings().presentationString(for: scenario)
    }
    
    func testProvideAppropriateStringForTutorialInitialLoadTitle() {
        let expected = "Offline Usage"
        XCTAssertEqual(expected, string(for: .tutorialInitialLoadTitle))
    }
    
}
