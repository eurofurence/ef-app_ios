import Foundation

public protocol NewsSceneDelegate {

    func newsSceneDidLoad()
    func newsSceneDidSelectComponent(at indexPath: IndexPath)
    func newsSceneDidPerformRefreshAction()

}

public protocol NewsScene: class {

    var delegate: NewsSceneDelegate? { get set }

    func showNewsTitle(_ title: String)
    func showRefreshIndicator()
    func hideRefreshIndicator()
    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder)

}
