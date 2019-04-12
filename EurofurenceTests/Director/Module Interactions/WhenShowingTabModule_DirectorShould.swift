@testable import Eurofurence
import EurofurenceModel
import XCTest

class FakeModuleOrderingPolicy: ModuleOrderingPolicy {

    private(set) var producedModules = [UIViewController]()
    func order(modules: [UIViewController]) -> [UIViewController] {
        producedModules = modules.randomized()
        return producedModules
    }

    private(set) var capturedModulesToSave = [UIViewController]()
    func saveOrder(_ modules: [UIViewController]) {
        capturedModulesToSave = modules
    }

}

extension Array {

    func randomized() -> [Element] {
        var copy = self
        var output = [Element]()
        while copy.isEmpty == false {
            let next = copy.randomElement()
            output.append(copy.remove(at: next.index))
        }

        return output
    }

}

class WhenShowingTabModule_DirectorShould: XCTestCase {

    func testShowTheModulesInOrderDesignatedByOrderingPolicy() {
        let context = ApplicationDirectorTestBuilder().build()
        let moduleOrderingPolicy = context.moduleOrderingPolicy
        context.navigateToTabController()

        let rootNavigationTabControllers = context.tabModule.capturedTabModules.compactMap({ $0 as? UINavigationController })
        let expectedModuleControllers = moduleOrderingPolicy.producedModules

        let expectedTabBarItems: [UITabBarItem] = expectedModuleControllers.map({ $0.tabBarItem })
        let actualTabBarItems: [UITabBarItem] = rootNavigationTabControllers.compactMap({ $0.tabBarItem })

        let expectedRestorationIdentifiers = rootNavigationTabControllers.compactMap({ $0.topViewController?.restorationIdentifier }).map({ "NAV_" + $0 })
        let actualRestorationIdentifiers = rootNavigationTabControllers.compactMap({ $0.restorationIdentifier })

        XCTAssertEqual(expectedModuleControllers, rootNavigationTabControllers)
        XCTAssertEqual(expectedTabBarItems, actualTabBarItems)
        XCTAssertEqual(expectedRestorationIdentifiers, actualRestorationIdentifiers)
    }

    func testTellThePolicyToSaveTabOrderWhenEditingFinishes() {
        let context = ApplicationDirectorTestBuilder().build()
        let moduleOrderingPolicy = context.moduleOrderingPolicy
        context.navigateToTabController()
        let rootNavigationTabControllers = context.tabModule.capturedTabModules.compactMap({ $0 as? UINavigationController })
        let tabBarController = context.tabModule.stubInterface
        tabBarController.delegate?.tabBarController?(tabBarController, didEndCustomizing: rootNavigationTabControllers, changed: true)

        XCTAssertEqual(rootNavigationTabControllers, moduleOrderingPolicy.capturedModulesToSave)
    }

}
