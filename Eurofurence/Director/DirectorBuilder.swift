import EurofurenceModel
import UIKit.UIViewController

class DirectorBuilder {

    private var animate: Bool
    private var linkLookupService: ContentLinksService
    private let moduleRepository: ModuleRepository
    private var orderingPolicy: ModuleOrderingPolicy
    
    private var windowWireframe: WindowWireframe
    private var navigationControllerFactory: NavigationControllerFactory
    private var tabModuleProviding: TabModuleProviding
    private var urlOpener: URLOpener

    init(moduleRepository: ModuleRepository, linkLookupService: ContentLinksService) {
        animate = true
        self.moduleRepository = moduleRepository
        orderingPolicy = RestorationIdentifierOrderingPolicy()
        windowWireframe = AppWindowWireframe.shared
        navigationControllerFactory = PlatformNavigationControllerFactory()
        tabModuleProviding = PlatformTabModuleFactory()

        self.linkLookupService = linkLookupService
        urlOpener = AppURLOpener()
    }

    @discardableResult
    func withAnimations(_ animate: Bool) -> DirectorBuilder {
        self.animate = animate
        return self
    }

    @discardableResult
    func with(_ orderingPolicy: ModuleOrderingPolicy) -> DirectorBuilder {
        self.orderingPolicy = orderingPolicy
        return self
    }

    @discardableResult
    func with(_ windowWireframe: WindowWireframe) -> DirectorBuilder {
        self.windowWireframe = windowWireframe
        return self
    }

    @discardableResult
    func with(_ navigationControllerFactory: NavigationControllerFactory) -> DirectorBuilder {
        self.navigationControllerFactory = navigationControllerFactory
        return self
    }

    @discardableResult
    func with(_ tabModuleProviding: TabModuleProviding) -> DirectorBuilder {
        self.tabModuleProviding = tabModuleProviding
        return self
    }

    @discardableResult
    func with(_ urlOpener: URLOpener) -> DirectorBuilder {
        self.urlOpener = urlOpener
        return self
    }

    func build() -> ApplicationDirector {
        return ApplicationDirector(animate: animate,
                                   moduleRepository: moduleRepository,
                                   linkLookupService: linkLookupService,
                                   urlOpener: urlOpener,
                                   orderingPolicy: orderingPolicy,
                                   windowWireframe: windowWireframe,
                                   navigationControllerFactory: navigationControllerFactory,
                                   tabModuleProviding: tabModuleProviding)
    }

}
