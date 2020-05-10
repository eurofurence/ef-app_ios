import UIKit

public protocol AnnouncementsComponentFactory {

    func makeAnnouncementsComponent(
        _ delegate: AnnouncementsComponentDelegate
    ) -> UIViewController

}
