//
//  MapCoordinateRender.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapCoordinateRender {

    func render(x: Int, y: Int, radius: Int, onto data: Data) -> Data

}
