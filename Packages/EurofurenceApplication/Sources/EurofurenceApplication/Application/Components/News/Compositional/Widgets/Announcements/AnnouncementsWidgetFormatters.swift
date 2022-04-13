import ComponentBase
import Foundation

public struct AnnouncementsWidgetFormatters {
    
    let announcementTimestamps: DateFormatterProtocol
    let markdownRenderer: MarkdownRenderer
    
    public init() {
        let announcementTimestamps = DateFormatter()
        announcementTimestamps.dateStyle = .short
        announcementTimestamps.timeStyle = .short
        
        self.init(announcementTimestamps: announcementTimestamps, markdownRenderer: SubtleDownMarkdownRenderer())
    }
    
    public init(announcementTimestamps: DateFormatterProtocol, markdownRenderer: MarkdownRenderer) {
        self.announcementTimestamps = announcementTimestamps
        self.markdownRenderer = markdownRenderer
    }
    
}
