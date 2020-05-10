@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class NewsPresenterTestBuilder {

    struct Context {

        var module: UIViewController
        var sceneFactory: StubNewsSceneFactory
        var newsScene: CapturingNewsScene
        var delegate: CapturingNewsComponentDelegate
        var newsInteractor: NewsViewModelProducer

    }

    private var sceneFactory: StubNewsSceneFactory
    private var delegate: CapturingNewsComponentDelegate
    private var newsInteractor: NewsViewModelProducer

    init() {
        sceneFactory = StubNewsSceneFactory()
        delegate = CapturingNewsComponentDelegate()
        newsInteractor = FakeNewsViewModelProducer()
    }

    @discardableResult
    func with(_ newsInteractor: NewsViewModelProducer) -> NewsPresenterTestBuilder {
        self.newsInteractor = newsInteractor
        return self
    }

    func build() -> Context {
        let module = NewsComponentBuilder(newsInteractor: newsInteractor)
            .with(sceneFactory)
            .build()
            .makeNewsComponent(delegate)

        return Context(module: module,
                       sceneFactory: sceneFactory,
                       newsScene: sceneFactory.stubbedScene,
                       delegate: delegate,
                       newsInteractor: newsInteractor)
    }

}

extension NewsPresenterTestBuilder {

    static func buildForAssertingAgainstEventComponent(eventViewModel: EventComponentViewModel) -> CapturingScheduleEventComponent {
        let viewModel = SingleEventNewsViewModel(event: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        let newsInteractor = StubNewsViewModelProducer(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
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
