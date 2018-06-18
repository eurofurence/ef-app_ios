//
//  DealersBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersBinder {

    func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath)

}
