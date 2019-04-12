import UIKit.UIViewController

protocol AnnouncementDetailSceneFactory {

    func makeAnnouncementDetailScene() -> UIViewController & AnnouncementDetailScene

}
