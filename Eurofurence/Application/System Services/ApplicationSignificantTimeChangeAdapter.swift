//
//  ApplicationSignificantTimeChangeAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ApplicationSignificantTimeChangeAdapter: SignificantTimeChangeAdapter {

    private var notificationRegistration: NSObjectProtocol?

    init() {
        notificationRegistration = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationSignificantTimeChange, object: nil, queue: .main) { (_) in
            self.delegate?.significantTimeChangeDidOccur()
        }
    }

    private var delegate: SignificantTimeChangeAdapterDelegate?
    func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate) {
        self.delegate = delegate
    }

}
