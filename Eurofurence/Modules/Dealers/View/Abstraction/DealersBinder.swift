import Foundation

protocol DealersBinder {

    func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath)
    func bind(_ component: DealerGroupHeader, toDealerGroupAt index: Int)

}
