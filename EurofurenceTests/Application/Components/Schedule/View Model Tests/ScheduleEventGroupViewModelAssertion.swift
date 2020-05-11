import Eurofurence
import EurofurenceModelTestDoubles
import TestUtilities

class ScheduleEventGroupViewModelAssertion: Assertion {

    private let context: ScheduleViewModelFactoryTestBuilder.Context
    private let groupDateFormatter: (Date) -> String

    class func assertionForEventViewModels(context: ScheduleViewModelFactoryTestBuilder.Context,
                                           file: StaticString = #file,
                                           line: UInt = #line) -> ScheduleEventGroupViewModelAssertion {
        return ScheduleEventGroupViewModelAssertion(context: context,
                                                    groupDateFormatter: context.hoursFormatter.hoursString,
                                                    file: file,
                                                    line: line)
    }

    class func assertionForSearchEventViewModels(context: ScheduleViewModelFactoryTestBuilder.Context,
                                                 file: StaticString = #file,
                                                 line: UInt = #line) -> ScheduleEventGroupViewModelAssertion {
        return ScheduleEventGroupViewModelAssertion(context: context,
                                                    groupDateFormatter: context.shortFormDayAndTimeFormatter.dayAndHoursString,
                                                    file: file,
                                                    line: line)
    }

    private init(context: ScheduleViewModelFactoryTestBuilder.Context, groupDateFormatter: @escaping (Date) -> String, file: StaticString = #file, line: UInt = #line) {
        self.context = context
        self.groupDateFormatter = groupDateFormatter

        super.init(file: file, line: line)
    }

    typealias Group = (date: Date, events: [FakeEvent])

    func assertEventGroupViewModels(_ expected: [ScheduleEventGroupViewModel], isModeledBy groups: [Group]) {
        guard expected.count == groups.count else {
            fail(message: "Expected \(expected.count) groups, got \(groups.count)")
            return
        }

        for (first, second) in zip(expected, groups) {
            assert(expected: first, isEqualTo: second)
        }
    }

    private func assert(expected: ScheduleEventGroupViewModel, isEqualTo group: Group) {
        guard expected.events.count == group.events.count else {
            fail(message: "Expected \(expected.events.count) events, got \(group.events.count)")
            return
        }

        let expectedTitle = groupDateFormatter(group.date)
        assert(expected.title, isEqualTo: expectedTitle)

        for (first, second) in zip(expected.events, group.events) {
            ScheduleEventViewModelAssertion(context: context, file: file, line: line)
                .assertEventViewModel(first, isModeledBy: second)
        }
    }

}
