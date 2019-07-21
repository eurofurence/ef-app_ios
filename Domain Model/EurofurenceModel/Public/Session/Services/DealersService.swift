import Foundation

public protocol DealersService {
    
    func fetchDealer(for identifier: DealerIdentifier) -> Dealer?
    func makeDealersIndex() -> DealersIndex

}
