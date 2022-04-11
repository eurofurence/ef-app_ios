import EurofurenceApplication
import EurofurenceModel
import Foundation
import XCTComponentBase
import XCTEurofurenceModel

class DefaultNewsViewModelProducerTestBuilder {

    struct Context {
        var viewModelFactory: DefaultNewsViewModelProducer
        var delegate: CapturingNewsViewModelRecipient
        var relativeTimeFormatter: FakeRelativeTimeIntervalCountdownFormatter
        var hoursDateFormatter: FakeHoursDateFormatter
        var authenticationService: FakeAuthenticationService
        var announcementsService: FakeAnnouncementsRepository
        var privateMessagesService: CapturingPrivateMessagesService
        var daysUntilConventionService: StubConventionCountdownService
        var eventsService: FakeScheduleRepository
        var clock: StubClock
        var refreshService: CapturingRefreshService
        var announcementDateFormatter: FakeAnnouncementDateFormatter
		var markdownRenderer: StubMarkdownRenderer
    }

    private var announcementsService: FakeAnnouncementsRepository
    private var authenticationService: FakeAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var daysUntilConventionService: StubConventionCountdownService
    private var eventsService: FakeScheduleRepository

    init() {
        announcementsService = FakeAnnouncementsRepository(announcements: [])
        authenticationService = FakeAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        daysUntilConventionService = StubConventionCountdownService()
        eventsService = FakeScheduleRepository()
    }

    @discardableResult
    func with(_ announcementsService: FakeAnnouncementsRepository) -> DefaultNewsViewModelProducerTestBuilder {
        self.announcementsService = announcementsService
        return self
    }

    @discardableResult
    func with(_ authService: FakeAuthenticationService) -> DefaultNewsViewModelProducerTestBuilder {
        self.authenticationService = authService
        return self
    }

    @discardableResult
    func with(_ privateMessagesService: CapturingPrivateMessagesService) -> DefaultNewsViewModelProducerTestBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }

    @discardableResult
    func with(_ daysUntilConventionService: StubConventionCountdownService) -> DefaultNewsViewModelProducerTestBuilder {
        self.daysUntilConventionService = daysUntilConventionService
        return self
    }

    @discardableResult
    func with(_ eventsService: FakeScheduleRepository) -> DefaultNewsViewModelProducerTestBuilder {
        self.eventsService = eventsService
        return self
    }

    func build() -> Context {
        let clock = StubClock()
        let relativeTimeFormatter = FakeRelativeTimeIntervalCountdownFormatter()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let refreshService = CapturingRefreshService()
        let announcementsDateFormatter = FakeAnnouncementDateFormatter()
		let markdownRenderer = StubMarkdownRenderer()
        let viewModelFactory = DefaultNewsViewModelProducer(announcementsService: announcementsService,
                                               authenticationService: authenticationService,
                                               privateMessagesService: privateMessagesService,
                                               daysUntilConventionService: daysUntilConventionService,
                                               eventsService: eventsService,
                                               relativeTimeIntervalCountdownFormatter: relativeTimeFormatter,
                                               hoursDateFormatter: hoursDateFormatter,
                                               clock: clock,
                                               refreshService: refreshService,
                                               announcementsDateFormatter: announcementsDateFormatter,
											   announcementsMarkdownRenderer: markdownRenderer)
        let delegate = CapturingNewsViewModelRecipient()

        return Context(viewModelFactory: viewModelFactory,
                       delegate: delegate,
                       relativeTimeFormatter: relativeTimeFormatter,
                       hoursDateFormatter: hoursDateFormatter,
                       authenticationService: authenticationService,
                       announcementsService: announcementsService,
                       privateMessagesService: privateMessagesService,
                       daysUntilConventionService: daysUntilConventionService,
                       eventsService: eventsService,
                       clock: clock,
                       refreshService: refreshService,
                       announcementDateFormatter: announcementsDateFormatter,
					   markdownRenderer: markdownRenderer)
    }

}
