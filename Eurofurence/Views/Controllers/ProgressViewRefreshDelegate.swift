//
//  ProgressViewRefreshDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class ProgressViewRefreshDelegate: DataStoreRefreshDelegate {

    let progressView: UIProgressView

	init(progressView: UIProgressView) {
		self.progressView = progressView
	}

	func dataStoreRefreshDidBegin(_ lastSync: Date?) {
        progressView.progress = 0
        progressView.alpha = 1
    }

    func dataStoreRefreshDidFinish() {
        hideProgressBar()
    }

    func dataStoreRefreshDidFailWithError(_ error: Error) {
        hideProgressBar()
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {
        progressView.progress = Float(progress.fractionCompleted)
    }

    private func animateProgressBarTransition(_ block: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15, animations: block)
    }

    private func hideProgressBar() {
        let oneSecond = DispatchTime(uptimeNanoseconds: DispatchTime.now().rawValue + NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: oneSecond) {
            UIView.animate(withDuration: 0.25) {
                self.progressView.alpha = 0
            }
        }
    }

}
