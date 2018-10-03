//
//  ApplicationSignificantTimeChangeAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

// TODO: Why are there two of these?

public class ApplicationSignificantTimeChangeAdapter: SignificantTimeChangeAdapter {

    private var notificationRegistration: NSObjectProtocol?

    public init() {
        notificationRegistration = NotificationCenter.default.addObserver(forName: UIApplication.significantTimeChangeNotification, object: nil, queue: .main) { (_) in
            self.delegate?.significantTimeChangeDidOccur()
        }
    }

    private var delegate: SignificantTimeChangeAdapterDelegate?
    public func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate) {
        self.delegate = delegate
    }

}

class ApplicationSignificantTimeChangeEventSource: SignificantTimeChangeEventSource {

    static let shared = ApplicationSignificantTimeChangeEventSource()
    private var observers = [SignificantTimeChangeEventObserver]()
    private var notificationHandler: NSObjectProtocol?

    private init() {
        notificationHandler = NotificationCenter.default.addObserver(forName: UIApplication.significantTimeChangeNotification,
                                                                     object: UIApplication.shared,
                                                                     queue: .main,
                                                                     using: significationTimeChangeNotificationHandler)
    }

    func add(_ observer: SignificantTimeChangeEventObserver) {
        observers.append(observer)
    }

    private func significationTimeChangeNotificationHandler(_ notification: Notification) {
        observers.forEach({ $0.significantTimeChangeDidOccur() })
    }

}
