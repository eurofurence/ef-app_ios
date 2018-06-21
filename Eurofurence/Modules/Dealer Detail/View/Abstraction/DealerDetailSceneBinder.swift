//
//  DealerDetailSceneBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealerDetailSceneBinder {

    func bindComponent<T>(at index: Int, using componentFactory: T) where T: DealerDetailComponentFactory

}
