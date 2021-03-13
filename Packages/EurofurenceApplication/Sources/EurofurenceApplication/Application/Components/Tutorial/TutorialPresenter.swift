import Foundation

class TutorialPresenter {

    // MARK: Properties

    private let delegate: TutorialComponentDelegate
    private var context: TutorialPresentationContext

    // MARK: Initialization

    init(delegate: TutorialComponentDelegate,
         context: TutorialPresentationContext) {
        self.delegate = delegate
        self.context = context

        let completeTutorial = CompleteTutorial(delegate: delegate,
                                                tutorialStateProviding: context.tutorialStateProviding)
        _ = InitiateDownloadTutorialPagePresenter(delegate: completeTutorial,
                                                  tutorialScene: context.tutorialScene,
                                                  alertRouter: context.alertRouter,
                                                  presentationAssets: context.presentationAssets,
                                                  networkReachability: context.networkReachability)
    }

}
