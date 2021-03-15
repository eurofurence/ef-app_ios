import EurofurenceApplication

class CapturingWidgetService: WidgetService {
    
    enum ReloadState: Equatable {
        case unset
        case reloadRequested(widgets: Set<String>)
    }
    
    private(set) var reloadState: ReloadState = .unset
    func reloadWidgets(identifiers: Set<String>) {
        reloadState = .reloadRequested(widgets: identifiers)
    }
    
}
