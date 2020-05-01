import UIKit

public protocol AnnouncementsModuleProviding {

    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController

}
