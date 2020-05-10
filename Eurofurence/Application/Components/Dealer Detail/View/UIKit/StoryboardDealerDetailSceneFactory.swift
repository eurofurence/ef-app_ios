import UIKit

struct StoryboardDealerDetailSceneFactory: DealerDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "DealerDetail", bundle: .main)

    func makeDealerDetailScene() -> UIViewController & DealerDetailScene {
        return storyboard.instantiate(DealerDetailViewController.self)
    }

}
