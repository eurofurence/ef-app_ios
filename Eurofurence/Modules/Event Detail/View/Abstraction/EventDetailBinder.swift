//
//  EventDetailBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventDetailBinder {

    func bindComponent<T>(at indexPath: IndexPath, using componentFactory: T) -> T.Component where T: EventDetailComponentFactory

}
