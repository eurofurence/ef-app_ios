import EurofurenceApplication
import EurofurenceModel
import UIKit.UIViewController
import XCTScheduleComponent

class NewsPresenterTestBuilder {

    struct Context {

        var module: UIViewController
        var sceneFactory: StubNewsSceneFactory
        var newsScene: CapturingNewsScene
        var delegate: CapturingNewsComponentDelegate
        var newsViewModelFactory: NewsViewModelProducer

    }

    private var sceneFactory: StubNewsSceneFactory
    private var delegate: CapturingNewsComponentDelegate
    private var newsViewModelFactory: NewsViewModelProducer

    init() {
        sceneFactory = StubNewsSceneFactory()
        delegate = CapturingNewsComponentDelegate()
        newsViewModelFactory = FakeNewsViewModelProducer()
    }

    @discardableResult
    func with(_ newsViewModelFactory: NewsViewModelProducer) -> NewsPresenterTestBuilder {
        self.newsViewModelFactory = newsViewModelFactory
        return self
    }

    func build() -> Context {
        let module = NewsComponentBuilder(newsViewModelProduer: newsViewModelFactory)
            .with(sceneFactory)
            .build()
            .makeNewsComponent(delegate)

        return Context(module: module,
                       sceneFactory: sceneFactory,
                       newsScene: sceneFactory.stubbedScene,
                       delegate: delegate,
                       newsViewModelFactory: newsViewModelFactory)
    }

}

extension NewsPresenterTestBuilder {

    static func buildForAssertingAgainstEventComponent(
        eventViewModel: EventComponentViewModel
    ) -> CapturingScheduleEventComponent {
        let viewModel = SingleEventNewsViewModel(event: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        let newsViewModelFactory = StubNewsViewModelProducer(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsViewModelFactory).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)

        return context.newsScene.stubbedEventComponent
    }

}

extension NewsPresenterTestBuilder.Context {

    func simulateNewsSceneDidLoad() {
        newsScene.delegate?.newsSceneDidLoad()
    }

    func simulateNewsSceneDidPerformRefreshAction() {
        newsScene.delegate?.newsSceneDidPerformRefreshAction()
    }

    @discardableResult
    func bindSceneComponent(at indexPath: IndexPath) -> Any? {
        return newsScene.bindComponent(at: indexPath)
    }

    func selectComponent(at indexPath: IndexPath) {
        newsScene.simulateSelectingComponent(at: indexPath)
    }

}
