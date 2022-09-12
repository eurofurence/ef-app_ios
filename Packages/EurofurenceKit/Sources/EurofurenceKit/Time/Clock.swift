import Combine
import Foundation

public protocol Clock {
    
    typealias SignificantTimeChangePublisher = CurrentValueSubject<Date, Never>
    
    var significantTimeChangePublisher: SignificantTimeChangePublisher { get }
    
}

public class DeviceSensitiveClock: Clock {
    
    public static let shared = DeviceSensitiveClock()
    
    private init() {
        
    }
    
    public let significantTimeChangePublisher = SignificantTimeChangePublisher(Date())
    
#if os(macOS)
    @objc private func calendarDayChanged(_ notification: Notification) {
        
    }
#endif
    
#if os(iOS)
    @objc private func significantTimeChange(_ notification: Notification) {
        
    }
#endif
    
    private func processSignificantTimeChange() {
        
    }
    
}
