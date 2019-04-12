import UIKit

struct StoryboardDealersSceneFactory: DealersSceneFactory {

    private let storyboard = UIStoryboard(name: "Dealers", bundle: .main)

    func makeDealersScene() -> UIViewController & DealersScene {
        return storyboard.instantiate(DealersViewController.self)
    }

}
