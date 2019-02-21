//
//  ScheduleEventGroupViewModelAssertion.swift
//  TestUtilities
//
//  Created by Thomas Sherwood on 21/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import TestUtilities

class ScheduleEventGroupViewModelAssertion: Assertion {

    func assertEventGroupViewModels(_ expected: [ScheduleEventGroupViewModel], isEqualTo actual: [ScheduleEventGroupViewModel]) {
        guard expected.count == actual.count else {
            fail(message: "Expected \(expected.count) groups, got \(actual.count)")
            return
        }

        for (first, second) in zip(expected, actual) {
            assert(expected: first, isEqualTo: second)
        }
    }

    private func assert(expected: ScheduleEventGroupViewModel, isEqualTo actual: ScheduleEventGroupViewModel) {
        guard expected.events.count == actual.events.count else {
            fail(message: "Expected \(expected.events.count) events, got \(actual.events.count)")
            return
        }

        assert(expected.title, isEqualTo: actual.title)

        for (first, second) in zip(expected.events, actual.events) {
            ScheduleEventViewModelAssertion().assertEventViewModel(first, isEqualTo: second)
        }
    }

}
