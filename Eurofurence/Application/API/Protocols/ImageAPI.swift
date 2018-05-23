//
//  ImageAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ImageAPI {

    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void)

}
