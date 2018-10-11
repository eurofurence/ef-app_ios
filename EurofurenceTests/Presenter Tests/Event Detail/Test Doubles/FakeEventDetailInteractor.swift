//
//  FakeEventDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import Foundation

struct FakeEventDetailInteractor: EventDetailInteractor {

    private let viewModel: EventDetailViewModel
    private let event: Event

    init(viewModel: EventDetailViewModel, for event: Event) {
        self.viewModel = viewModel
        self.event = event
    }

    func makeViewModel(for event: Event.Identifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        if event == self.event.identifier {
            completionHandler(viewModel)
        }
    }

}
