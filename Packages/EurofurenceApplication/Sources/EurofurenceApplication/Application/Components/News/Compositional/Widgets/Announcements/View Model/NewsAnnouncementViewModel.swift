import ObservedObject

public protocol NewsAnnouncementViewModel: ObservedObject {
    
    var title: String { get }
    var isUnreadIndicatorVisible: Bool { get }
    
    func open()
    
}
