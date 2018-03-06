//
//  ApplicationPreloadingService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class ApplicationPreloadingService: PreloadService {

    private let app: EurofurenceApplicationProtocol
    private var observations = [Any]()

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    func beginPreloading(delegate: PreloadServiceDelegate) {
        let progress = app.refreshLocalStore { (error) in
            if error == nil {
                delegate.preloadServiceDidFinish()
            } else {
                delegate.preloadServiceDidFail()
            }
        }

        var totalUnitCount = 0
        var completedUnitCount = 0

        let updateProgress = { delegate.preloadServiceDidProgress(currentUnitCount: completedUnitCount, totalUnitCount: totalUnitCount) }

        observations.append(progress.observe(\.totalUnitCount, options: [.new]) { (_, change) in
            if let value = change.newValue {
                totalUnitCount = Int(value)
                updateProgress()
            }
        })

        observations.append(progress.observe(\.completedUnitCount, options: [.new]) { (_, change) in
            if let value = change.newValue {
                completedUnitCount = Int(value)
                updateProgress()
            }
        })
    }

}
