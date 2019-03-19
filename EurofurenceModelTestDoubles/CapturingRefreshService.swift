//
//  CapturingRefreshService.swift
//  EurofurenceModelTestDoubles
//
//  Created by Thomas Sherwood on 04/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

public class CapturingRefreshService: RefreshService {

    public init() {

    }

    private var refreshCompletionHandler: ((RefreshServiceError?) -> Void)?
    private(set) public var toldToRefresh = false
    fileprivate var refreshProgress: Progress?
    public func refreshLocalStore(completionHandler: @escaping (RefreshServiceError?) -> Void) -> Progress {
        toldToRefresh = true
        refreshCompletionHandler = completionHandler
        refreshProgress = Progress()

        return refreshProgress!
    }

    private(set) var refreshObservers = [RefreshServiceObserver]()
    public func add(_ observer: RefreshServiceObserver) {
        refreshObservers.append(observer)
    }

    public func failLastRefresh(error: RefreshServiceError = .apiError) {
        refreshCompletionHandler?(error)
    }

    public func succeedLastRefresh() {
        refreshCompletionHandler?(nil)
    }

    public func updateProgressForCurrentRefresh(currentUnitCount: Int, totalUnitCount: Int) {
        refreshProgress?.totalUnitCount = Int64(totalUnitCount)
        refreshProgress?.completedUnitCount = Int64(currentUnitCount)
    }

}

public extension CapturingRefreshService {

    public func simulateRefreshBegan() {
        refreshObservers.forEach { $0.refreshServiceDidBeginRefreshing() }
    }

    public func simulateRefreshFinished() {
        refreshObservers.forEach { $0.refreshServiceDidFinishRefreshing() }
    }

}
