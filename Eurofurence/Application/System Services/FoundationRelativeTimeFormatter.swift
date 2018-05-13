//
//  FoundationRelativeTimeFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct FoundationRelativeTimeFormatter: RelativeTimeFormatter {
    
    static let shared = FoundationRelativeTimeFormatter()
    private var formatter: DateComponentsFormatter
    
    private init() {
        formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
    }
    
    func relativeString(from timeInterval: TimeInterval) -> String {
        return formatter.string(from: timeInterval)!
    }
    
}
