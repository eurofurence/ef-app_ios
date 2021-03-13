import Foundation

public protocol DealersSearchResultsBinder {

    func bind(_ component: DealerComponent, toDealerSearchResultAt indexPath: IndexPath)
    func bind(_ component: DealerGroupHeader, toDealerSearchResultGroupAt index: Int)

}
