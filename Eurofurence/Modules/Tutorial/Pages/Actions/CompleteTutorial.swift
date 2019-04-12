struct CompleteTutorial: TutorialPageDelegate {

    var delegate: TutorialModuleDelegate
    var tutorialStateProviding: UserCompletedTutorialStateProviding

    func tutorialPageCompletedByUser(_ tutorialPage: TutorialPage) {
        delegate.tutorialModuleDidFinishPresentingTutorial()
        tutorialStateProviding.markTutorialAsComplete()
    }

}
