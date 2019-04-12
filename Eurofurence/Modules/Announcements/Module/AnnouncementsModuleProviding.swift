import UIKit

protocol AnnouncementsModuleProviding {

    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController

}
