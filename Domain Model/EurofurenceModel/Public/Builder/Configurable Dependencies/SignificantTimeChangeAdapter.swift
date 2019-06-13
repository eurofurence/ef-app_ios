import Foundation

public protocol SignificantTimeChangeAdapter {

    func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate)

}

public protocol SignificantTimeChangeAdapterDelegate {

    func significantTimeChangeDidOccur()

}
