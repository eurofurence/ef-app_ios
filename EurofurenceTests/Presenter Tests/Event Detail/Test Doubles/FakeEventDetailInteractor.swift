//
//  FakeEventDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

struct FakeEventDetailInteractor: EventDetailInteractor {

    private let viewModel: EventDetailViewModel
    private let event: EventProtocol

    init(viewModel: EventDetailViewModel, for event: EventProtocol) {
        self.viewModel = viewModel
        self.event = event
    }

    func makeViewModel(for event: EventIdentifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        if event == self.event.identifier {
            completionHandler(viewModel)
        }
    }

}
