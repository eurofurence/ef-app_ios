import UIKit

struct StoryboardAnnouncementDetailSceneFactory: AnnouncementDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "AnnouncementDetail", bundle: .module)

    func makeAnnouncementDetailScene() -> UIViewController & AnnouncementDetailScene {
        return storyboard.instantiate(AnnouncementDetailViewController.self)
    }

}
