import RouterCore

public struct MVVMWidget<
    ViewModelFactory: NewsWidgetViewModelFactory,
    ViewFactory: NewsWidgetViewFactory
>: NewsWidget where ViewModelFactory.ViewModel == ViewFactory.ViewModel {
    
    private let viewModelFactory: ViewModelFactory
    private let viewFactory: ViewFactory
    
    public init(viewModelFactory: ViewModelFactory, viewFactory: ViewFactory) {
        self.viewModelFactory = viewModelFactory
        self.viewFactory = viewFactory
    }
    
    public func register(in environment: NewsWidgetEnvironment) {
        let viewModel = viewModelFactory.makeViewModel(router: environment.router)
        let visualController = viewFactory.makeVisualController(viewModel: viewModel)
        environment.install(dataSource: visualController)
    }
    
}
