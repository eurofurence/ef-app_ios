//
//  ModuleAttacher.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol ModuleAttacher {

    func attach(to wireframe: PresentationWireframe)

}

protocol PresentationWireframe: class {

    func setRoot(_ scene: AnyObject)

}
