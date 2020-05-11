import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class DefaultNewsViewModelProducerTestBuilder {

    struct Context {
        var viewModelFactory: DefaultNewsViewModelProducer
        var delegate: CapturingNewsViewModelRecipient
        var relativeTimeFormatter: FakeRelativeTimeIntervalCountdownFormatter
        var hoursDateFormatter: FakeHoursDateFormatter
        var authenticationService: FakeAuthenticationService
        var announcementsService: FakeAnnouncementsService
        var privateMessagesService: CapturingPrivateMessagesService
        var daysUntilConventionService: StubConventionCountdownService
        var eventsService: FakeEventsService
        var clock: StubClock
        var refreshService: CapturingRefreshService
        var announcementDateFormatter: FakeAnnouncementDateFormatter
		var markdownRenderer: StubMarkdownRenderer
    }

    private var announcementsService: FakeAnnouncementsService
    private var authenticationService: FakeAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var daysUntilConventionService: StubConventionCountdownService
    private var eventsService: FakeEventsService

    init() {
        announcementsService = FakeAnnouncementsService(announcements: [])
        authenticationService = FakeAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        daysUntilConventionService = StubConventionCountdownService()
        eventsService = FakeEventsService()
    }

    @discardableResult
    func with(_ announcementsService: FakeAnnouncementsService) -> DefaultNewsViewModelProducerTestBuilder {
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
    func with(_ eventsService: FakeEventsService) -> DefaultNewsViewModelProducerTestBuilder {
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
