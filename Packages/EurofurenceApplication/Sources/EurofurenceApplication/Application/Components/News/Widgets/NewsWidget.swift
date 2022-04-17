import RouterCore

public protocol NewsWidget {
    
    func register(in environment: NewsWidgetEnvironment)
    
}

public protocol NewsWidgetEnvironment {
    
    var router: Router { get }
    
    func install(dataSource: TableViewMediator)
    
}
