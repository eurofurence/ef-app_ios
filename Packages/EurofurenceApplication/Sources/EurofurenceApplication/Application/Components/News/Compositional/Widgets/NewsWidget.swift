public protocol NewsWidget {
    
    func register(in manager: NewsWidgetManager)
    
}

public protocol NewsWidgetManager: AnyObject {
    
    func install(dataSource: TableViewMediator)
    
}

public protocol NewsWidgetManagerDelegate {
    
    func newsWidgetManagerReadyForWidgets()
    
}
