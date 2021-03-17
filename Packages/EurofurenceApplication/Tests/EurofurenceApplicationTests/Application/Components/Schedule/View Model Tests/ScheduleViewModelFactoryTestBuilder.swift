import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import XCTComponentBase

class FakeShortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter {

    private var strings = [Date: String]()

    func dayAndHoursString(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        } else {
            strings[date] = output
        }

        return output
    }

}

class ScheduleViewModelFactoryTestBuilder {

    struct Context {
        var viewModelFactory: DefaultScheduleViewModelFactory
        var eventsService: FakeEventsService
        var hoursFormatter: FakeHoursDateFormatter
        var shortFormDateFormatter: FakeShortFormDateFormatter
        var shortFormDayAndTimeFormatter: FakeShortFormDayAndTimeFormatter
        let viewModelDelegate = CapturingScheduleViewModelDelegate()
        let searchViewModelDelegate = CapturingScheduleSearchViewModelDelegate()
        var refreshService: CapturingRefreshService
        var shareService: CapturingShareService
    }

    private var eventsService: FakeEventsService

    init() {
        eventsService = FakeEventsService()
    }

    @discardableResult
    func with(_ eventsService: FakeEventsService) -> ScheduleViewModelFactoryTestBuilder {
        self.eventsService = eventsService
        return self
    }

    func build() -> Context {
        let hoursFormatter = FakeHoursDateFormatter()
        let shortFormDateFormatter = FakeShortFormDateFormatter()
        let shortFormDayAndTimeFormatter = FakeShortFormDayAndTimeFormatter()
        let refreshService = CapturingRefreshService()
        let shareService = CapturingShareService()
        let viewModelFactory = DefaultScheduleViewModelFactory(
            eventsService: eventsService,
            hoursDateFormatter: hoursFormatter,
            shortFormDateFormatter: shortFormDateFormatter,
            shortFormDayAndTimeFormatter: shortFormDayAndTimeFormatter,
            refreshService: refreshService,
            shareService: shareService
        )

        return Context(
            viewModelFactory: viewModelFactory,
            eventsService: eventsService,
            hoursFormatter: hoursFormatter,
            shortFormDateFormatter: shortFormDateFormatter,
            shortFormDayAndTimeFormatter: shortFormDayAndTimeFormatter,
            refreshService: refreshService,
            shareService: shareService
        )
    }

}

extension ScheduleViewModelFactoryTestBuilder.Context {

    var eventsViewModels: [ScheduleEventGroupViewModel] {
        return viewModelDelegate.eventsViewModels
    }

    var daysViewModels: [ScheduleDayViewModel] {
        return viewModelDelegate.daysViewModels
    }

    var currentDayIndex: Int? {
        return viewModelDelegate.currentDayIndex
    }

    @discardableResult
    func makeViewModel() -> ScheduleViewModel? {
        var viewModel: ScheduleViewModel?
        viewModelFactory.makeViewModel { (vm) in
            viewModel = vm
            vm.setDelegate(self.viewModelDelegate)
        }

        return viewModel
    }

    @discardableResult
    func makeSearchViewModel() -> ScheduleSearchViewModel? {
        var searchViewModel: ScheduleSearchViewModel?
        viewModelFactory.makeSearchViewModel { (viewModel) in
            searchViewModel = viewModel
            viewModel.setDelegate(self.searchViewModelDelegate)
        }

        return searchViewModel
    }

    func makeExpectedDayViewModel(from day: Day) -> ScheduleDayViewModel {
        return ScheduleDayViewModel(title: shortFormDateFormatter.dateString(from: day.date))
    }

}
