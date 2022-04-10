import RouterCore

public struct ConventionCountdownViewModelFactory<
    DataSource: ConventionCountdownDataSource
>: NewsWidgetViewModelFactory {
    
    private let dataSource: DataSource
    
    public init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    public typealias ViewModel = DataSourceBackedConventionCountdownViewModel
    
    public func makeViewModel(router: Router) -> ViewModel {
        DataSourceBackedConventionCountdownViewModel(dataSource: dataSource)
    }
    
}
