//
//  EntityBase.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class EntityBase {
    var Id : UUID = ""
    var LastChangeDateTimeUtc : Date = Date()
	
	var IsDeleted : Bool = false
}
