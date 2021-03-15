import UIKit

struct StoryboardMapDetailSceneFactory: MapDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "MapDetail", bundle: .module)

    func makeMapDetailScene() -> UIViewController & MapDetailScene {
        return storyboard.instantiate(MapDetailViewController.self)
    }

}
