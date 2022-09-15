#if canImport(AppKit)
import AppKit
#endif
import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// A `Clock` that adapts significant time signals for the currently executing platform.
public class DeviceSensitiveClock: Clock {
    
    public static let shared = DeviceSensitiveClock()
    
    private convenience init() {
        self.init(notificationCenter: .default)
    }
    
    init(notificationCenter: NotificationCenter) {
#if os(iOS)
        notificationCenter.addObserver(
            self,
            selector: #selector(processSignificantTimeChange(_:)),
            name: UIApplication.significantTimeChangeNotification,
            object: nil
        )
#elseif os(macOS)
        notificationCenter.addObserver(
            self,
            selector: #selector(processSignificantTimeChange(_:)),
            name: .NSCalendarDayChanged,
            object: nil
        )
#endif
    }
    
    public let significantTimeChangePublisher = SignificantTimeChangePublisher(Date())
    
    @objc private func processSignificantTimeChange(_ notification: Notification) {
        significantTimeChangePublisher.send(Date())
    }
    
}
