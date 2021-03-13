import EurofurenceApplication

struct WiFiNetwork: NetworkReachability {

    var wifiReachable: Bool {
        return true
    }
    
    var cellularReachable: Bool {
        return false
    }

}

struct CellularNetwork: NetworkReachability {

    var wifiReachable: Bool {
        return false
    }
    
    var cellularReachable: Bool {
        return true
    }

}

struct NoNetwork: NetworkReachability {
    
    var wifiReachable: Bool {
        return false
    }
    
    var cellularReachable: Bool {
        return false
    }
    
}
