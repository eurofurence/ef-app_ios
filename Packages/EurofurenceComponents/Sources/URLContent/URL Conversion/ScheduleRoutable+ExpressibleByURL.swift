import Foundation
import ScheduleComponent
import URLRouteable

extension ScheduleRouteable: ExpressibleByURL {
    
    public init?(url: URL) {
        guard url.absoluteString.contains("Events") else { return nil }
        self.init()
    }
    
}
