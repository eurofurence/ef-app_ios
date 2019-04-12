import UIKit

struct StoryboardAnnouncementsSceneFactory: AnnouncementsSceneFactory {

    private let storyboard = UIStoryboard(name: "Announcements", bundle: .main)

    func makeAnnouncementsScene() -> UIViewController & AnnouncementsScene {
        return storyboard.instantiate(AnnouncementsViewController.self)
    }

}
