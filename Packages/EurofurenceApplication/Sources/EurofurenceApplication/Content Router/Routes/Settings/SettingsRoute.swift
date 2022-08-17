import ComponentBase
import RouterCore
import UIKit

public struct SettingsRoute {
    
    private let modalWireframe: any ModalWireframe
    private let settingsModuleFactory: any SettingsModuleFactory
    
    public init(modalWireframe: any ModalWireframe, settingsModuleFactory: any SettingsModuleFactory) {
        self.modalWireframe = modalWireframe
        self.settingsModuleFactory = settingsModuleFactory
    }
    
}

// MARK: - SettingsRoute + Route

extension SettingsRoute: Route {
    
    public typealias Parameter = SettingsRouteable
    
    public func route(_ parameter: Parameter) {
        let viewController = settingsModuleFactory.makeSettingsModule()
        
        if let barButtonItem = parameter.sender as? UIBarButtonItem {
            viewController.modalPresentationStyle = .popover
            viewController.popoverPresentationController?.barButtonItem = barButtonItem
        }
        
        modalWireframe.presentModalContentController(viewController)
    }
    
}
