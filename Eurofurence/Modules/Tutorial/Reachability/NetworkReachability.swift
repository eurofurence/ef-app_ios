import Foundation

public protocol NetworkReachability {

    var wifiReachable: Bool { get }
    var cellularReachable: Bool { get }

}
