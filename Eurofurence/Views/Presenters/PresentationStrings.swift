//
//  PresentationStrings.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol PresentationStrings {

    func presentationString(for scenario: PresentationScenario) -> String?

}

enum PresentationScenario {
    case tutorialInitialLoadTitle
}

struct UnlocalizedPresentationStrings: PresentationStrings {
    
    func presentationString(for scenario: PresentationScenario) -> String? {
        return "Offline Usage"
    }

}
