import ScheduleComponent
import TestUtilities
import XCTEurofurenceModel

class ScheduleEventViewModelAssertion: Assertion {

    private let context: ScheduleViewModelFactoryTestBuilder.Context

    init(context: ScheduleViewModelFactoryTestBuilder.Context, file: StaticString = #file, line: UInt = #line) {
        self.context = context
        super.init(file: file, line: line)
    }

    func assertEventViewModel(_ viewModel: ScheduleEventViewModelProtocol,
                              isModeledBy event: FakeEvent) {
        let expectedStartTime = context.hoursFormatter.hoursString(from: event.startDate)
        let expectedEndTime = context.hoursFormatter.hoursString(from: event.endDate)

        assert(viewModel.title, isEqualTo: event.title)
        assert(viewModel.startTime, isEqualTo: expectedStartTime)
        assert(viewModel.endTime, isEqualTo: expectedEndTime)
        assert(viewModel.location, isEqualTo: event.room.name)
        assert(viewModel.bannerGraphicPNGData, isEqualTo: event.bannerGraphicPNGData)
        assert(viewModel.isFavourite, isEqualTo: event.isFavourite)
        assert(viewModel.isSponsorOnly, isEqualTo: event.isSponsorOnly)
        assert(viewModel.isSuperSponsorOnly, isEqualTo: event.isSuperSponsorOnly)
        assert(viewModel.isArtShow, isEqualTo: event.isArtShow)
        assert(viewModel.isKageEvent, isEqualTo: event.isKageEvent)
        assert(viewModel.isDealersDenEvent, isEqualTo: event.isDealersDen)
        assert(viewModel.isMainStageEvent, isEqualTo: event.isMainStage)
        assert(viewModel.isPhotoshootEvent, isEqualTo: event.isPhotoshoot)
        assert(viewModel.isAcceptingFeedback, isEqualTo: event.isAcceptingFeedback)
        assert(viewModel.isFaceMaskRequired, isEqualTo: event.isFaceMaskRequired)
    }

}
