import UIKit.UIViewController

public protocol AnnouncementDetailSceneFactory {

    func makeAnnouncementDetailScene() -> UIViewController & AnnouncementDetailScene

}
