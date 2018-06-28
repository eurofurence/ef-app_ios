//
//  Array+AppExtensions.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    func contains(elementsFrom other: [Element]) -> Bool {
        for element in other {
            guard contains(element) else { return false }
        }
        
        return true
    }
    
}
