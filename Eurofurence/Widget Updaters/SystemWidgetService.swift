import WidgetKit

struct SystemWidgetService: WidgetService {
    
    func reloadWidgets(identifiers: Set<String>) {
        guard #available(iOS 14.0, *) else { return }
        
        let widgetCenter = WidgetCenter.shared
        for identifier in identifiers {
            widgetCenter.reloadTimelines(ofKind: identifier)
        }
    }
    
}
