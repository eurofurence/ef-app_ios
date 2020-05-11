import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class SchedulePresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingScheduleScene
        var delegate: CapturingScheduleComponentDelegate
        var hapticEngine: CapturingSelectionChangedHaptic
    }

    private var viewModelFactory: ScheduleViewModelFactory

    init() {
        viewModelFactory = FakeScheduleViewModelFactory()
    }

    @discardableResult
    func with(_ viewModelFactory: ScheduleViewModelFactory) -> SchedulePresenterTestBuilder {
        self.viewModelFactory = viewModelFactory
        return self
    }

    func build() -> Context {
        let sceneFactory = StubScheduleSceneFactory()
        let delegate = CapturingScheduleComponentDelegate()
        let hapticEngine = CapturingSelectionChangedHaptic()
        let viewController = ScheduleModuleBuilder(scheduleViewModelFactory: viewModelFactory)
            .with(sceneFactory)
            .with(hapticEngine)
            .build()
            .makeScheduleComponent(delegate)

        return Context(producedViewController: viewController,
                       scene: sceneFactory.scene,
                       delegate: delegate,
                       hapticEngine: hapticEngine)
    }

}

extension SchedulePresenterTestBuilder {

    static func buildForTestingBindingOfEvent(_ event: ScheduleEventViewModelProtocol) -> CapturingScheduleEventComponent {
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [event])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)

        return component
    }

}

extension SchedulePresenterTestBuilder {

    static func buildForTestingBindingOfSearchResult(_ event: ScheduleEventViewModelProtocol) -> CapturingScheduleEventComponent {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let results = [ScheduleEventGroupViewModel(title: .random, events: [event])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)

        return component
    }

}

extension SchedulePresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.scheduleSceneDidLoad()
    }

    func simulateSceneDidSelectEvent(at indexPath: IndexPath) {
        scene.delegate?.scheduleSceneDidSelectEvent(at: indexPath)
    }

    func simulateSceneDidSelectSearchResult(at indexPath: IndexPath) {
        scene.delegate?.scheduleSceneDidSelectSearchResult(at: indexPath)
    }

    func simulateSceneDidSelectDay(at index: Int) {
        scene.delegate?.scheduleSceneDidSelectDay(at: index)
    }

    func simulateSceneDidUpdateSearchQuery(_ query: String) {
        scene.delegate?.scheduleSceneDidUpdateSearchQuery(query)
    }

    func simulateSceneDidPerformRefreshAction() {
        scene.delegate?.scheduleSceneDidPerformRefreshAction()
    }

    func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
        scene.binder?.bind(header, forGroupAt: index)
    }

    func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath) {
        scene.binder?.bind(eventComponent, forEventAt: indexPath)
    }

    func bind(_ dayComponent: ScheduleDayComponent, forDayAt index: Int) {
        scene.daysBinder?.bind(dayComponent, forDayAt: index)
    }

    func bindSearchResultComponent(_ component: ScheduleEventComponent, forSearchResultAt indexPath: IndexPath) {
        scene.searchResultsBinder?.bind(component, forEventAt: indexPath)
    }

    func bindSearchResultHeading(_ component: ScheduleEventGroupHeader, forSearchResultGroupAt index: Int) {
        scene.searchResultsBinder?.bind(component, forGroupAt: index)
    }

}
