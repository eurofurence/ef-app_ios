//
//  StubWebMobuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation.NSURL
import UIKit.UIViewController

class StubWebMobuleProviding: WebModuleProviding {
    
    var producedWebModules = [URL : UIViewController]()
    func makeWebModule(for url: URL) -> UIViewController {
        let module = UIViewController()
        producedWebModules[url] = module
        
        return module
    }
    
}
