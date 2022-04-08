import EventDetailComponent
import RouterCore

struct CompositionalNewsRoutesToDelegate: Router {
    
    let delegate: any NewsComponentDelegate
    
    func route<R>(_ content: R) throws where R: Routeable {
        if let content = content as? EventRouteable {
            delegate.newsModuleDidSelectEvent(content.identifier)
        }
    }
    
}
