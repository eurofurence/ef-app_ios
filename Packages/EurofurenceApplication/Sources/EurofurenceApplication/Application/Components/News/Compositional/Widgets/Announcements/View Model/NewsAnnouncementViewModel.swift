import Foundation
import ObservedObject

public protocol NewsAnnouncementViewModel: ObservedObject {
    
    var formattedTimestamp: String { get }
    var title: String { get }
    var body: NSAttributedString { get }
    var isUnreadIndicatorVisible: Bool { get }
    
    func open()
    
}
