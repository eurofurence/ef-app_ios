struct CompleteTutorial: TutorialPageDelegate {

    var delegate: TutorialComponentDelegate
    var tutorialStateProviding: UserCompletedTutorialStateProviding

    func tutorialPageCompletedByUser(_ tutorialPage: TutorialPage) {
        delegate.tutorialModuleDidFinishPresentingTutorial()
        tutorialStateProviding.markTutorialAsComplete()
    }

}
