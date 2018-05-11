//
//  ApplicationSignificantTimeChangeEventSource.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIApplication

class ApplicationSignificantTimeChangeEventSource: SignificantTimeChangeEventSource {

    static let shared = ApplicationSignificantTimeChangeEventSource()
    private var observers = [SignificantTimeChangeEventObserver]()
    private var notificationHandler: NSObjectProtocol?

    private init() {
        notificationHandler = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationSignificantTimeChange,
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
