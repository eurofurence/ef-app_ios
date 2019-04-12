protocol RootModuleProviding {

    func makeRootModule(_ delegate: RootModuleDelegate)

}

protocol RootModuleDelegate {

    func rootModuleDidDetermineTutorialShouldBePresented()
    func rootModuleDidDetermineStoreShouldRefresh()
    func rootModuleDidDetermineRootModuleShouldBePresented()

}
