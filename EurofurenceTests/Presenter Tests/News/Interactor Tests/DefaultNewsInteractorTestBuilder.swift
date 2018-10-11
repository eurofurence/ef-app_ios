//
//  DefaultNewsInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import Foundation
import XCTest

class CapturingRefreshService: RefreshService {
    
    private(set) var toldToRefresh = false
    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        toldToRefresh = true
        return Progress()
    }
    
    private(set) var refreshObservers = [RefreshServiceObserver]()
    func add(_ observer: RefreshServiceObserver) {
        refreshObservers.append(observer)
    }
    
}

extension CapturingRefreshService {
    
    func simulateRefreshBegan() {
        refreshObservers.forEach { $0.refreshServiceDidBeginRefreshing() }
    }
    
    func simulateRefreshFinished() {
        refreshObservers.forEach { $0.refreshServiceDidFinishRefreshing() }
    }
    
}

class FakeAnnouncementDateFormatter: AnnouncementDateFormatter {
    
    private var strings = [Date : String]()
    
    func string(from date: Date) -> String {
        var output = String.random
        if let previous = strings[date] {
            output = previous
        }
        else {
            strings[date] = output
        }
        
        return output
    }
    
}

class DefaultNewsInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultNewsInteractor
        var delegate: CapturingNewsInteractorDelegate
        var relativeTimeFormatter: FakeRelativeTimeIntervalCountdownFormatter
        var hoursDateFormatter: FakeHoursDateFormatter
        var authenticationService: FakeAuthenticationService
        var announcementsService: StubAnnouncementsService
        var privateMessagesService: CapturingPrivateMessagesService
        var daysUntilConventionService: StubConventionCountdownService
        var eventsService: FakeEventsService
        var dateDistanceCalculator: StubDateDistanceCalculator
        var clock: StubClock
        var refreshService: CapturingRefreshService
        var announcementDateFormatter: FakeAnnouncementDateFormatter
		var markdownRenderer: StubMarkdownRenderer
    }
    
    private var announcementsService: StubAnnouncementsService
    private var authenticationService: FakeAuthenticationService
    private var privateMessagesService: CapturingPrivateMessagesService
    private var daysUntilConventionService: StubConventionCountdownService
    private var eventsService: FakeEventsService
    
    init() {
        announcementsService = StubAnnouncementsService(announcements: [])
        authenticationService = FakeAuthenticationService(authState: .loggedOut)
        privateMessagesService = CapturingPrivateMessagesService()
        daysUntilConventionService = StubConventionCountdownService()
        eventsService = FakeEventsService()
    }
    
    @discardableResult
    func with(_ announcementsService: StubAnnouncementsService) -> DefaultNewsInteractorTestBuilder {
        self.announcementsService = announcementsService
        return self
    }
    
    @discardableResult
    func with(_ authService: FakeAuthenticationService) -> DefaultNewsInteractorTestBuilder {
        self.authenticationService = authService
        return self
    }
    
    @discardableResult
    func with(_ privateMessagesService: CapturingPrivateMessagesService) -> DefaultNewsInteractorTestBuilder {
        self.privateMessagesService = privateMessagesService
        return self
    }
    
    @discardableResult
    func with(_ daysUntilConventionService: StubConventionCountdownService) -> DefaultNewsInteractorTestBuilder {
        self.daysUntilConventionService = daysUntilConventionService
        return self
    }
    
    @discardableResult
    func with(_ eventsService: FakeEventsService) -> DefaultNewsInteractorTestBuilder {
        self.eventsService = eventsService
        return self
    }
    
    func build() -> Context {
        let dateDistanceCalculator = StubDateDistanceCalculator()
        let clock = StubClock()
        let relativeTimeFormatter = FakeRelativeTimeIntervalCountdownFormatter()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let refreshService = CapturingRefreshService()
        let announcementsDateFormatter = FakeAnnouncementDateFormatter()
		let markdownRenderer = StubMarkdownRenderer()
        let interactor = DefaultNewsInteractor(announcementsService: announcementsService,
                                               authenticationService: authenticationService,
                                               privateMessagesService: privateMessagesService,
                                               daysUntilConventionService: daysUntilConventionService,
                                               eventsService: eventsService,
                                               relativeTimeIntervalCountdownFormatter: relativeTimeFormatter,
                                               hoursDateFormatter: hoursDateFormatter,
                                               dateDistanceCalculator: dateDistanceCalculator,
                                               clock: clock,
                                               refreshService: refreshService,
                                               announcementsDateFormatter: announcementsDateFormatter,
											   announcementsMarkdownRenderer: markdownRenderer)
        let delegate = CapturingNewsInteractorDelegate()
        
        return Context(interactor: interactor,
                       delegate: delegate,
                       relativeTimeFormatter: relativeTimeFormatter,
                       hoursDateFormatter: hoursDateFormatter,
                       authenticationService: authenticationService,
                       announcementsService: announcementsService,
                       privateMessagesService: privateMessagesService,
                       daysUntilConventionService: daysUntilConventionService,
                       eventsService: eventsService,
                       dateDistanceCalculator: dateDistanceCalculator,
                       clock: clock,
                       refreshService: refreshService,
                       announcementDateFormatter: announcementsDateFormatter,
					   markdownRenderer: markdownRenderer)
    }
    
}

// MARK: Convenience Functions

extension DefaultNewsInteractorTestBuilder.Context {
    
    func subscribeViewModelUpdates() {
        interactor.subscribeViewModelUpdates(delegate)
    }
    
    var announcements: [Announcement] {
        return announcementsService.announcements
    }
    
    var displayedAnnouncements: [Announcement] {
        return Array(announcementsService.announcements.prefix(3))
    }
    
    var runningEvents: [Event] {
        return eventsService.runningEvents
    }
    
    func assert() -> AssertionBuilder {
        return AssertionBuilder(context: self)
    }
    
    class ViewModelAssertionBuilder {
        
        fileprivate struct Component: CustomStringConvertible {
            var title: String
            var components: [AnyHashable]
            
            var description: String {
                return "\(title) | \(components)"
            }
        }
        
        private var components = [Component]()
        private let context: DefaultNewsInteractorTestBuilder.Context
        
        fileprivate init(context: DefaultNewsInteractorTestBuilder.Context) {
            self.context = context
        }
        
        func verify(file: StaticString = #file, line: UInt = #line) {
            Assertion(file: file, line: line, components: components, viewModel: context.delegate.viewModel).verify()
        }
        
        private var shouldSimulateUserHasUnreadMessages: Bool {
            return context.privateMessagesService.unreadCount > 0
        }
        
        func hasYourEurofurence() -> ViewModelAssertionBuilder {
            var component: AnyHashable
            switch context.authenticationService.authState {
            case .loggedIn(let user):
                component = UserWidgetComponentViewModel(prompt: String.welcomePrompt(for: user),
                                                         detailedPrompt: String.welcomeDescription(messageCount: context.privateMessagesService.unreadCount),
                                                         hasUnreadMessages: shouldSimulateUserHasUnreadMessages)
                
            case .loggedOut:
                component = UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                         detailedPrompt: .anonymousUserLoginDescription,
                                                         hasUnreadMessages: shouldSimulateUserHasUnreadMessages)
            }
            
            components.append(Component(title: .yourEurofurence, components: [component]))
            
            return self
        }
        
        func hasAnnouncements() -> ViewModelAssertionBuilder {
            let allAnnouncementsComponent = ViewAllAnnouncementsComponentViewModel(caption: .allAnnouncements)
            let announcementsComponents = context.announcements.prefix(3).map(makeExpectedAnnouncementViewModel)
            components.append(Component(title: .announcements, components: [allAnnouncementsComponent] + announcementsComponents))
            
            return self
        }
        
        func hasConventionCountdown() -> ViewModelAssertionBuilder {
            let daysUntilConvention = resolveStubbedDaysUntilConvention()
            let component = ConventionCountdownComponentViewModel(timeUntilConvention: .daysUntilConventionMessage(days: daysUntilConvention))
            components.append(Component(title: .daysUntilConvention, components: [component]))
            
            return self
        }
        
        func hasRunningEvents() -> ViewModelAssertionBuilder {
            let eventsComponents = context.eventsService.runningEvents.map(makeExpectedEventViewModelForRunningEvent)
            components.append(Component(title: .runningEvents, components: eventsComponents))
            
            return self
        }
        
        func hasUpcomingEvents() -> ViewModelAssertionBuilder {
            let eventsComponents = context.eventsService.upcomingEvents.map(makeExpectedEventViewModelForUpcomingEvent)
            components.append(Component(title: .upcomingEvents, components: eventsComponents))
            
            return self
        }
        
        func hasFavouriteEvents() -> ViewModelAssertionBuilder {
            let expectedEvents = context.eventsService.allEvents.filter({ context.eventsService.favourites.contains($0.identifier) }).map(makeExpectedViewModelForFavouriteEvent)
            components.append(Component(title: .todaysFavouriteEvents, components: expectedEvents))
            
            return self
        }
        
        private func makeExpectedAnnouncementsViewModelsFromStubbedAnnouncements() -> [AnyHashable] {
            return context.announcements.map(makeExpectedAnnouncementViewModel)
        }
        
        private func makeExpectedAnnouncementViewModel(from announcement: Announcement) -> AnyHashable {
            return AnnouncementComponentViewModel(title: announcement.title,
                                                  detail: context.markdownRenderer.stubbedContents(for: announcement.content),
                                                  receivedDateTime: context.announcementDateFormatter.string(from: announcement.date),
                                                  isRead: context.announcementsService.stubbedReadAnnouncements.contains(announcement.identifier))
        }
        
        private func resolveStubbedDaysUntilConvention() -> Int {
            guard case .countingDown(let days) = context.daysUntilConventionService.countdownState else { return -1 }
            return days
        }
        
        private func makeExpectedEventViewModelForRunningEvent(from event: Event) -> AnyHashable {
            return makeExpectedEventViewModel(event: event,
                                              startTime: .now,
                                              endTime: context.hoursDateFormatter.hoursString(from: event.endDate))
        }
        
        private func makeExpectedEventViewModelForUpcomingEvent(from event: Event) -> AnyHashable {
            let timeDifference = event.startDate.timeIntervalSince1970 - context.clock.currentDate.timeIntervalSince1970
            return makeExpectedEventViewModel(event: event,
                                              startTime: context.relativeTimeFormatter.relativeString(from: timeDifference),
                                              endTime: context.hoursDateFormatter.hoursString(from: event.endDate))
        }
        
        private func makeExpectedViewModelForFavouriteEvent(from event: Event) -> AnyHashable {
            let isFavourite = context.eventsService.favourites.contains(event.identifier)
            return makeExpectedEventViewModel(event: event,
                                              startTime: context.hoursDateFormatter.hoursString(from: event.startDate),
                                              endTime: context.hoursDateFormatter.hoursString(from: event.endDate),
                                              isFavourite: isFavourite)
        }
        
        private func makeExpectedEventViewModel(event: Event,
                                                startTime: String,
                                                endTime: String,
                                                isFavourite: Bool = false) -> AnyHashable {
            return EventComponentViewModel(startTime: startTime,
                                           endTime: endTime,
                                           eventName: event.title,
                                           location: event.room.name,
                                           isSponsorEvent: event.isSponsorOnly,
                                           isSuperSponsorEvent: event.isSuperSponsorOnly,
                                           isFavourite: isFavourite,
                                           isArtShowEvent: event.isArtShow,
                                           isKageEvent: event.isKageEvent,
                                           isDealersDenEvent: event.isDealersDen,
                                           isMainStageEvent: event.isMainStage,
                                           isPhotoshootEvent: event.isPhotoshoot)
        }
        
    }
    
    struct ModelAssertionBuilder {
        
        var context: DefaultNewsInteractorTestBuilder.Context
        
        func at(indexPath: IndexPath, is expected: NewsViewModelValue, file: StaticString = #file, line: UInt = #line) {
            guard let viewModel = context.delegate.viewModel else {
                XCTFail("Did not witness a view model", file: file, line: line)
                return
            }
            
            var fetchedValue: NewsViewModelValue?
            viewModel.fetchModelValue(at: indexPath) { fetchedValue = $0 }
            
            guard let actual = fetchedValue else {
                XCTFail("Failed to fetch a model at index path \(indexPath)", file: file, line: line)
                return
            }
            
            XCTAssertEqual(expected, actual, file: file, line: line)
        }
        
    }

    class AssertionBuilder {
        
        private let context: DefaultNewsInteractorTestBuilder.Context
        
        fileprivate init(context: DefaultNewsInteractorTestBuilder.Context) {
            self.context = context
        }
        
        func thatViewModel() -> ViewModelAssertionBuilder {
            return ViewModelAssertionBuilder(context: context)
        }
        
        func thatModel() -> ModelAssertionBuilder {
            return ModelAssertionBuilder(context: context)
        }
        
    }

}

fileprivate extension DefaultNewsInteractorTestBuilder.Context {
    
    fileprivate struct Assertion {
        
        var file: StaticString
        var line: UInt
        var components: [ViewModelAssertionBuilder.Component]
        var viewModel: NewsViewModel?
        
        private class Visitor: NewsViewModelVisitor {
            var components = [AnyHashable]()
            
            func visit(_ userWidget: UserWidgetComponentViewModel) {
                components.append(AnyHashable(userWidget))
            }
            
            func visit(_ announcement: AnnouncementComponentViewModel) {
                components.append(AnyHashable(announcement))
            }
            
            func visit(_ viewAllAnnouncements: ViewAllAnnouncementsComponentViewModel) {
                components.append(viewAllAnnouncements)
            }
            
            func visit(_ event: EventComponentViewModel) {
                components.append(AnyHashable(event))
            }
            
            func visit(_ countdown: ConventionCountdownComponentViewModel) {
                components.append(AnyHashable(countdown))
            }
        }
        
        func verify() {
            guard let viewModel = viewModel else {
                XCTFail("Delegate did not witness a view model",
                        file: file,
                        line: line)
                return
            }
            
            let actual = traverse(through: viewModel)
            
            guard actual.count == components.count else {
                let description = "Expected \(components.count) components; got \(actual.count)\n\n\(components)\n\n\(actual)"
                XCTFail(description,
                    file: file,
                    line: line)
                return
            }
            
            for (idx, component) in components.enumerated() {
                let actualComponent = actual[idx]
                verify(expected: component, actual: actualComponent, index: idx)
            }
        }
        
        private func traverse(through viewModel: NewsViewModel) -> [ViewModelAssertionBuilder.Component] {
            var actual = [ViewModelAssertionBuilder.Component]()
            for sectionIndex in (0..<viewModel.numberOfComponents) {
                let visitor = Visitor()
                var component = ViewModelAssertionBuilder.Component(title: viewModel.titleForComponent(at: sectionIndex), components: [])
                for itemIndex in (0..<viewModel.numberOfItemsInComponent(at: sectionIndex)) {
                    let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                    viewModel.describeComponent(at: indexPath, to: visitor)
                }
                
                component.components = visitor.components
                actual.append(component)
            }
            
            return actual
        }
        
        private func verify(expected: ViewModelAssertionBuilder.Component, actual: ViewModelAssertionBuilder.Component, index: Int) {
            guard expected.title == actual.title else {
                XCTFail("Component at index \(index) should have had title \"\(expected.title)\", but got \"\(actual.title)\"",
                    file: file,
                    line: line)
                return
            }
            
            guard expected.components.count == actual.components.count else {
                XCTFail("Expected component at index \(index) to have \(expected.components.count) components, but got \(actual.components.count)",
                    file: file,
                    line: line)
                return
            }
            
            for (idx, expectedComponent) in expected.components.enumerated() {
                let actualComponent = actual.components[idx]
                guard expectedComponent == actualComponent else {
                    XCTFail("Components at \(index)-\(idx) not equal: expected \(expectedComponent); got \(actualComponent)",
                        file: file,
                        line: line)
                    return
                }
            }
        }
        
    }
    
}
