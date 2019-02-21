//
//  StubMapContentOptionsViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation
import TestUtilities

final class StubMapContentOptionsViewModel: MapContentOptionsViewModel {

    let optionsHeading: String
    let options: [String]

    init(optionsHeading: String, options: [String]) {
        self.optionsHeading = optionsHeading
        self.options = options
    }

    private(set) var selectedOptionIndex: Int?
    func selectOption(at index: Int) {
        selectedOptionIndex = index
    }

}

extension StubMapContentOptionsViewModel: RandomValueProviding {

    static var random: StubMapContentOptionsViewModel {
        return StubMapContentOptionsViewModel(optionsHeading: .random, options: .random)
    }

}
