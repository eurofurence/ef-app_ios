import ComponentBase
import Foundation

struct InitiateDownloadTutorialPagePresenter: TutorialPage,
                                              TutorialPageSceneDelegate {

    private var delegate: TutorialPageDelegate
    private var networkReachability: NetworkReachability
    private var alertRouter: AlertRouter

    init(delegate: TutorialPageDelegate,
         tutorialScene: TutorialScene,
         alertRouter: AlertRouter,
         presentationAssets: PresentationAssets,
         networkReachability: NetworkReachability) {
        self.delegate = delegate
        self.alertRouter = alertRouter
        self.networkReachability = networkReachability

        var tutorialPage = tutorialScene.showTutorialPage()
        tutorialPage.tutorialPageSceneDelegate = self
        tutorialPage.showPageImage(presentationAssets.initialLoadInformationAsset)
        
        tutorialPage.showPageTitle(NSLocalizedString(
            "tutorialInitialLoadTitle",
            bundle: .module,
            comment: "Title telling the user we need to perform the initial download before they can use the app"
        ))
        
        tutorialPage.showPageDescription(NSLocalizedString(
            "tutorialInitialLoadDescription",
            bundle: .module,
            comment: "Description telling the user we need to perform the initial download before they can use the app"
        ))
        
        tutorialPage.showPrimaryActionButton()
        
        tutorialPage.showPrimaryActionDescription(NSLocalizedString(
            "tutorialInitialLoadBeginDownload",
            bundle: .module,
            comment: "Text used in the button where the user allows us to begin the initial download"
        ))
    }

    func tutorialPageSceneDidTapPrimaryActionButton(_ tutorialPageScene: TutorialPageScene) {
        if networkReachability.wifiReachable {
            delegate.tutorialPageCompletedByUser(self)
        } else if networkReachability.cellularReachable {
            let useCellularTitle = NSLocalizedString(
                "cellularDownloadAlertContinueOverCellularTitle",
                bundle: .module,
                comment: "Confirmation action allowing the initial download to begin over cellular"
            )
            
            let allowCellularDownloads = AlertAction(title: useCellularTitle, action: {
                self.delegate.tutorialPageCompletedByUser(self)
            })
            
            let cancel = AlertAction(title: .cancel)
            
            let cellularDownloadAlertTitle = NSLocalizedString(
                "cellularDownloadAlertTitle",
                bundle: .module,
                comment: "Title for the prompt asking if the user wants to download over cellular data"
            )
            
            let cellularDownloadAlertMessage = NSLocalizedString(
                "cellularDownloadAlertMessage",
                bundle: .module,
                comment: "Description for the prompt asking if the user wants to download over cellular data"
            )

            let alert = Alert(
                title: cellularDownloadAlertTitle,
                message: cellularDownloadAlertMessage,
                actions: [allowCellularDownloads, cancel]
            )
            
            alertRouter.show(alert)
        } else {
            let noNetworkTitle = NSLocalizedString(
                "noNetworkAlertTitle",
                bundle: .module,
                comment: "Title for the alert when the initial sync fails due to no network"
            )
            
            let noNetworkMessage = NSLocalizedString(
                "noNetworkAlertMessage",
                bundle: .module,
                comment: "Alert body when the initial sync fails due to no network"
            )
            
            let ok = AlertAction(title: .ok)
            let alert = Alert(title: noNetworkTitle, message: noNetworkMessage, actions: [ok])
            alertRouter.show(alert)
        }
    }

    func tutorialPageSceneDidTapSecondaryActionButton(_ tutorialPageScene: TutorialPageScene) {
    }

}
