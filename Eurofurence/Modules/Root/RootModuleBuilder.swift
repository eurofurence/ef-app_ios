import EurofurenceModel

struct RootModuleBuilder {

    var sessionStateService: SessionStateService

    func build() -> RootModuleProviding {
        return RootModule(sessionStateService: sessionStateService)
    }

}
