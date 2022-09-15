#if canImport(AppKit)
import AppKit
#endif
@testable import EurofurenceKit
import Foundation
#if canImport(UIKit)
import UIKit
#endif
import XCTest

class DeviceSensitiveClockTests: XCTestCase {
    
    func testProvidesCurrentTimeOnSubscribing() throws {
        let notificationCenter = NotificationCenter()
        let clock = DeviceSensitiveClock(notificationCenter: notificationCenter)
        
        var receivedTime: Date?
        let subscription = clock.significantTimeChangePublisher.sink { time in receivedTime = time }
        
        addTeardownBlock {
            subscription.cancel()
        }
        
        let time = try XCTUnwrap(receivedTime)
        
        XCTAssertEqual(
            time.timeIntervalSince1970,
            Date().timeIntervalSince1970,
            accuracy: 1,
            "Expected to receive the current time on subscribing"
        )
    }
    
#if canImport(UIKit)
    func testPostsUpdateOnSignificantTimeChange() {
        let notificationCenter = NotificationCenter()
        let clock = DeviceSensitiveClock(notificationCenter: notificationCenter)
        
        var postedSignificantTimeChanged = false
        let subscription = clock
            .significantTimeChangePublisher
            .dropFirst()
            .sink { _ in postedSignificantTimeChanged = true }
        
        addTeardownBlock {
            subscription.cancel()
        }
        
        notificationCenter.post(name: UIApplication.significantTimeChangeNotification, object: nil)
        
        XCTAssertTrue(postedSignificantTimeChanged, "Expected a time update on significant time changes")
    }
#endif
    
#if canImport(AppKit)
    func testPostsUpdateOnCalendarDayChanged() {
        let notificationCenter = NotificationCenter()
        let clock = DeviceSensitiveClock(notificationCenter: notificationCenter)
        
        var postedSignificantTimeChanged = false
        let subscription = clock
            .significantTimeChangePublisher
            .dropFirst()
            .sink { _ in postedSignificantTimeChanged = true }
        
        addTeardownBlock {
            subscription.cancel()
        }
        
        notificationCenter.post(name: .NSCalendarDayChanged, object: nil)
        
        XCTAssertTrue(postedSignificantTimeChanged, "Expected a time update on significant time changes")
    }
#endif

}
