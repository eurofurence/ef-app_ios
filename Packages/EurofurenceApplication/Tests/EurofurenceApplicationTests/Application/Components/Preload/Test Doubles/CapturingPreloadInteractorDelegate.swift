import EurofurenceApplication
import EurofurenceModel

class CapturingPreloadInteractorDelegate: PreloadInteractorDelegate {

    private(set) var wasToldPreloadInteractorDidFailToPreload = false
    func preloadInteractorDidFailToPreload() {
        wasToldPreloadInteractorDidFailToPreload = true
    }

    private(set) var wasToldPreloadInteractorDidFinishPreloading = false
    func preloadInteractorDidFinishPreloading() {
        wasToldPreloadInteractorDidFinishPreloading = true
    }
    
    private(set) var wasToldPreloadFailedDueToOldAppDetected = false
    func preloadInteractorFailedToLoadDueToOldAppDetected() {
        wasToldPreloadFailedDueToOldAppDetected = true
    }

    private(set) var capturedProgressCurrentUnitCount: Int?
    private(set) var capturedProgressTotalUnitCount: Int?
    private(set) var capturedProgressLocalizedDescription: String?
    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int, localizedDescription: String) {
        capturedProgressCurrentUnitCount = currentUnitCount
        capturedProgressTotalUnitCount = totalUnitCount
        capturedProgressLocalizedDescription = localizedDescription
    }

}
