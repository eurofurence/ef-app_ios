import UIKit

public protocol AnnouncementsSceneFactory {

    func makeAnnouncementsScene() -> UIViewController & AnnouncementsScene

}
