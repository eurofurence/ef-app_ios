//
//  SignificantTimeChangeAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol SignificantTimeChangeAdapter {

    func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate)

}

protocol SignificantTimeChangeAdapterDelegate {

    func significantTimeChangeDidOccur()

}
