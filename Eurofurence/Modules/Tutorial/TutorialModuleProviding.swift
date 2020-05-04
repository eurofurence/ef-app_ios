import UIKit

public protocol TutorialModuleProviding {

    func makeTutorialModule(_ delegate: TutorialModuleDelegate) -> UIViewController

}
