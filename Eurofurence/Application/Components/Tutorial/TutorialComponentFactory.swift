import UIKit

public protocol TutorialComponentFactory {

    func makeTutorialModule(_ delegate: TutorialComponentDelegate) -> UIViewController

}
