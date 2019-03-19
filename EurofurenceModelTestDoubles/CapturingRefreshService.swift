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

    private var refreshCompletionHandler: ((Error?) -> Void)?
    private(set) public var toldToRefresh = false
    fileprivate var refreshProgress: Progress?
    public func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        toldToRefresh = true
        refreshCompletionHandler = completionHandler
        refreshProgress = Progress()

        return refreshProgress!
    }

    private(set) var refreshObservers = [RefreshServiceObserver]()
    public func add(_ observer: RefreshServiceObserver) {
        refreshObservers.append(observer)
    }

    struct SomeError: Error {}
    public func failLastRefresh() {
        refreshCompletionHandler?(SomeError())
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
