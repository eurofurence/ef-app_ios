import EurofurenceModel

struct DonateIntentDealerInteractionRecorder: DealerInteractionRecorder {
    
    private let viewDealerIntentDonor: ViewDealerIntentDonor
    private let dealersService: DealersService
    
    init(dealersService: DealersService, viewDealerIntentDonor: ViewDealerIntentDonor) {
        self.dealersService = dealersService
        self.viewDealerIntentDonor = viewDealerIntentDonor
    }
    
    func makeInteraction(for dealer: DealerIdentifier) -> Interaction? {
        guard let entity = dealersService.fetchDealer(for: dealer) else { return nil }
        
        let intentDefinition = ViewDealerIntentDefinition(identifier: dealer, dealerName: entity.preferredName)
        viewDealerIntentDonor.donate(intentDefinition)
        
        return nil
    }
    
}
