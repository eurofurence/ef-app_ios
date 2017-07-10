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

    private func string(for scenario: PresentationScenario) -> String {
        return UnlocalizedPresentationStrings().presentationString(for: scenario)
    }
    
    func testProvideAppropriateStringForTutorialInitialLoadTitle() {
        let expected = "Offline Usage"
        XCTAssertEqual(expected, string(for: .tutorialInitialLoadTitle))
    }

    func testProvideAppropriateStringForTutorialInitialLoadDescription() {
        let expected = "The Eurofurence app is intended to remain fully functional while offline. To do this, we need to download a few megabytes of data. This may take several minutes depending upon the speed of your connection."
        XCTAssertEqual(expected, string(for: .tutorialInitialLoadDescription))
    }

    func testProvideAppropriateStringForTutorialInitialDownloadBeginDownload() {
        let expected = "Begin Download"
        XCTAssertEqual(expected, string(for: .tutorialInitialLoadBeginDownload))
    }
    
}
