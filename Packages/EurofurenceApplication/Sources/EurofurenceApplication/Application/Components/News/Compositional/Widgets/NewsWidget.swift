public protocol NewsWidget {
    
    func register(in manager: NewsWidgetManager)
    
}

public protocol NewsWidgetManager {
    
    func install(dataSource: TableViewMediator)
    
}
