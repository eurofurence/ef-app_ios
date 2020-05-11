import EurofurenceModel

public struct DonateIntentDealerInteractionRecorder: DealerInteractionRecorder {
    
    private let viewDealerIntentDonor: ViewDealerIntentDonor
    private let dealersService: DealersService
    private let activityFactory: ActivityFactory
    
    public init(
        viewDealerIntentDonor: ViewDealerIntentDonor,
        dealersService: DealersService,
        activityFactory: ActivityFactory
    ) {
        self.viewDealerIntentDonor = viewDealerIntentDonor
        self.dealersService = dealersService
        self.activityFactory = activityFactory
    }
    
    public func makeInteraction(for dealer: DealerIdentifier) -> Interaction? {
        guard let entity = dealersService.fetchDealer(for: dealer) else { return nil }
        
        let intentDefinition = ViewDealerIntentDefinition(identifier: dealer, dealerName: entity.preferredName)
        viewDealerIntentDonor.donate(intentDefinition)
        
        let activityTitle = String.viewDealer(named: entity.preferredName)
        let url = entity.makeContentURL()
        let activity = activityFactory.makeActivity(type: "org.eurofurence.activity.view-dealer", title: activityTitle, url: url)
        activity.markEligibleForPublicIndexing()
        
        return ActivityInteraction(activity: activity)
    }
    
}
