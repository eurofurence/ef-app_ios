import RouterCore

public struct YourEurofurenceWidgetViewModelFactory<
    DataSource: YourEurofurenceDataSource
>: NewsWidgetViewModelFactory {
    
    private let dataSource: DataSource
    
    public init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    public typealias ViewModel = DataSourceBackedYourEurofurenceWidgetViewModel
    
    public func makeViewModel(router: Router) -> ViewModel {
        DataSourceBackedYourEurofurenceWidgetViewModel(dataSource: dataSource, router: router)
    }
    
}
