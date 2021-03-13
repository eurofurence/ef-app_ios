import Foundation

public protocol DealerDetailSceneBinder {

    func bindComponent<T>(
        at index: Int,
        using componentFactory: T
    ) -> T.Component where T: DealerDetailItemComponentFactory

}
