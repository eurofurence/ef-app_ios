import Combine
import Foundation

/// A type that adapts the system's temporal state.
public protocol Clock {
    
    /// A publisher that emits a `Date` whenever a significant change in time occurs.
    typealias SignificantTimeChangePublisher = CurrentValueSubject<Date, Never>
    
    /// An combine pipeline that publishes values whenever a significant change in the current time occurs (e.g. change
    /// of day).
    var significantTimeChangePublisher: SignificantTimeChangePublisher { get }
    
}
