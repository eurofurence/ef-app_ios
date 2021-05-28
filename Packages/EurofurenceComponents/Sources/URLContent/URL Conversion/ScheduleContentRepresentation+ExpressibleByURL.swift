import Foundation
import ScheduleComponent

extension ScheduleContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        guard url.absoluteString.contains("Events") else { return nil }
        self.init()
    }
    
}
