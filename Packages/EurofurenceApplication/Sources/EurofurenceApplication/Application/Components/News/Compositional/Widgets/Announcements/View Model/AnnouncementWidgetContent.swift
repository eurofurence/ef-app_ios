public enum AnnouncementWidgetContent<ViewModel>: Equatable where ViewModel: NewsAnnouncementViewModel {
    
    public static func == (lhs: AnnouncementWidgetContent, rhs: AnnouncementWidgetContent) -> Bool {
        switch (lhs, rhs) {
        case (.showMoreAnnouncements, .showMoreAnnouncements):
            return true
            
        case (.announcement(let lhs), .announcement(let rhs)):
            return lhs === rhs
            
        default:
            return false
        }
    }
    
    case showMoreAnnouncements
    case announcement(ViewModel)
    
    public var viewModel: ViewModel? {
        if case .announcement(let viewModel) = self {
            return viewModel
        } else {
            return nil
        }
    }
    
}
