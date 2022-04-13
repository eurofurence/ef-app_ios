import EventDetailComponent
import RouterCore

struct CompositionalNewsRoutesToDelegate: Router {
    
    let delegate: any NewsComponentDelegate
    
    func route<R>(_ content: R) throws where R: Routeable {
        if let content = content as? EventRouteable {
            delegate.newsModuleDidSelectEvent(content.identifier)
        }
        
        if content is MessagesRouteable {
            delegate.newsModuleDidRequestShowingPrivateMessages()
        }
        
        if content is AnnouncementsRouteable {
            delegate.newsModuleDidRequestShowingAllAnnouncements()
        }
        
        if let content = content as? AnnouncementRouteable {
            delegate.newsModuleDidSelectAnnouncement(content.identifier)
        }
    }
    
}
