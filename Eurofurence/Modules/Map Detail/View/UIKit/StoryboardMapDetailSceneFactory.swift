import UIKit

struct StoryboardMapDetailSceneFactory: MapDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "MapDetail", bundle: .main)

    func makeMapDetailScene() -> UIViewController & MapDetailScene {
        return storyboard.instantiate(MapDetailViewController.self)
    }

}
