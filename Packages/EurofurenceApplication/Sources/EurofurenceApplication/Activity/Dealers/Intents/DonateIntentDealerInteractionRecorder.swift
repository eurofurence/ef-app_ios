import EurofurenceModel

public struct DonateIntentDealerInteractionRecorder: DealerInteractionRecorder {
    
    private let viewDealerIntentDonor: ViewDealerIntentDonor?
    private let dealersService: DealersService
    private let activityFactory: ActivityFactory
    
    public init(
        viewDealerIntentDonor: ViewDealerIntentDonor?,
        dealersService: DealersService,
        activityFactory: ActivityFactory
    ) {
        self.viewDealerIntentDonor = viewDealerIntentDonor
        self.dealersService = dealersService
        self.activityFactory = activityFactory
    }
    
    public func makeInteraction(for dealer: DealerIdentifier) -> Interaction? {
        guard let entity = dealersService.fetchDealer(for: dealer) else { return nil }
        
        let activityTitle = String.viewDealer(named: entity.preferredName)
        let url = entity.contentURL
        let activity = activityFactory.makeActivity(
            type: "org.eurofurence.activity.view-dealer",
            title: activityTitle,
            url: url
        )
        
        activity.markEligibleForPublicIndexing()
        
        let intentDefinition = ViewDealerIntentDefinition(identifier: dealer, dealerName: entity.preferredName)
        let donation = DealerDonation(intentDefinition: intentDefinition, donor: viewDealerIntentDonor)
        
        return ActivityInteraction(activity: activity, donation: donation)
    }
    
    private struct DealerDonation: ActivityDonation {
        
        var intentDefinition: ViewDealerIntentDefinition
        var donor: ViewDealerIntentDonor?
        
        func donate() {
            donor?.donate(intentDefinition)
        }
        
    }
    
}
