import RouterCore

public struct EventsWidgetViewModelFactory<T>: NewsWidgetViewModelFactory where T: EventsWidgetDataSource {
    
    private let dataSource: T
    private let description: String
    
    public init(dataSource: T, description: String) {
        self.dataSource = dataSource
        self.description = description
    }
    
    public typealias ViewModel = DataSourceBackedEventsWidgetViewModel
    
    public func makeViewModel(router: Router) -> ViewModel {
        DataSourceBackedEventsWidgetViewModel(
            interactor: dataSource,
            description: description,
            router: router
        )
    }
    
}
