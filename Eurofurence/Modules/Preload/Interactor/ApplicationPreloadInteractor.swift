//
//  ApplicationPreloadInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class ApplicationPreloadInteractor: PreloadInteractor {

    private let app: EurofurenceApplicationProtocol
    private var observations = [Any]()

    convenience init() {
        self.init(app: EurofurenceApplication.shared)
    }

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    func beginPreloading(delegate: PreloadInteractorDelegate) {
        let progress = app.refreshLocalStore { (error) in
            if error == nil {
                delegate.preloadInteractorDidFinishPreloading()
            } else {
                delegate.preloadInteractorDidFailToPreload()
            }
        }

        var totalUnitCount = 0
        var completedUnitCount = 0

        let updateProgress = {
            delegate.preloadInteractorDidProgress(currentUnitCount: completedUnitCount,
                                                  totalUnitCount: totalUnitCount,
                                                  localizedDescription: progress.localizedDescription ?? "")
        }

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
