import TutorialComponent
import UIKit

struct StubTutorialSceneFactory: TutorialSceneFactory {

    let tutorialScene = CapturingTutorialScene()
    func makeTutorialScene() -> UIViewController & TutorialScene {
        return tutorialScene
    }

}

class CapturingTutorialScene: UIViewController, TutorialScene {

    let tutorialPage = CapturingTutorialPageScene()

    private(set) var wasToldToShowTutorialPage = false
    private(set) var numberOfPagesShown = 0
    func showTutorialPage() -> TutorialPageScene {
        wasToldToShowTutorialPage = true
        numberOfPagesShown += 1
        return tutorialPage
    }

}
