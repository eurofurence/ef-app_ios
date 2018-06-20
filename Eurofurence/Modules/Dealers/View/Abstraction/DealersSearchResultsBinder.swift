//
//  DealersSearchResultsBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersSearchResultsBinder {

    func bind(_ component: DealerComponent, toDealerSearchResultAt indexPath: IndexPath)

}
