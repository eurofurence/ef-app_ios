import EurofurenceModel

struct RootModule: RootModuleProviding {

    var sessionStateService: SessionStateService

    func makeRootModule(_ delegate: RootModuleDelegate) {
        let actions: [EurofurenceSessionState : () -> Void] = [
            .uninitialized: delegate.rootModuleDidDetermineTutorialShouldBePresented,
            .stale: delegate.rootModuleDidDetermineStoreShouldRefresh,
            .initialized: delegate.rootModuleDidDetermineRootModuleShouldBePresented
        ]

        sessionStateService.determineSessionState { actions[$0]!() }
    }

}
