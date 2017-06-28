//
//  RoutingAppChooser.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

class RoutingAppChooser {
    static let sharedInstance = RoutingAppChooser()
    
    private let customAllowedSet =  CharacterSet(charactersIn:"=\"#%/<>?@\\^`{|}").inverted
    private var routingApps : [String:String] = [:]
    private var currentURLs : [String:URL] = [:]
    var selectionAlert : UIAlertController!
    
    private init() {
        /*
         Placeholders to be used in app URL pattern
         %name%       - name of target POI
         %house%      - house number
         %street%     - street name
         %zip%        - zip code for city
         %city%       - city
         %country%    - country
         %country-a3% - ISO 3166-1 alpha-3 code for country [http://unstats.un.org/unsd/methods/m49/m49alpha.htm]
         %lat%        - latitude
         %lon%        - longitude
         */
        
        /* Need support for more routing apps? Open for any suggestions! =D */
        routingApps["Apple Maps"] = "http://maps.apple.com/?q=%name%,%house%,%street%,%city%,%country%"
        routingApps["Google Maps"] = "comgooglemaps://?q=%name%,%house%,%street%,%city%,%country%"
        routingApps["Navigon"] = "navigon://address/%name%/%country-a3%/%zip%/%city%/%street%/%house%"
        routingApps["Garmin StreetPilot"] = "garminonboardwesterneurope://gm?action=map&name=%name%&address=%street%+%house%&%city=%city%" // this is purely guesswork and might potentially not work
        routingApps["Navmii"] = "navmii://%lat%,%lon%"
        routingApps["Waze"] = "waze://?q=%name%,%house%,%street%,%city%,%country%"
        
        pruneUnavailableApps()
        
        selectionAlert = UIAlertController(title: "Choose Routing Application", message: "Choose which app you would like to open the location of the convention in. Please note that not all of these apps may work offline!", preferredStyle: .alert)
        
        addAppActions()
    }
    
    private func pruneUnavailableApps() {
        var pruneCount = 0
        for routingApp in routingApps.keys {
            if !isAppAvailable(routingApp) {
                routingApps.removeValue(forKey: routingApp)
                pruneCount += 1
                print("Pruned", routingApp)
            }
        }
        print("Pruned", pruneCount, "unavailable routing apps")
    }
    
    private func addAppActions() {
        for routingApp in routingApps.keys {
            let action = UIAlertAction(title: routingApp, style: .default) { (alert: UIAlertAction!) -> Void in
                if self.currentURLs[routingApp] != nil {
                    UIApplication.shared.openURL(self.currentURLs[routingApp]!)
                } else {
                    print("Currently no URL for", routingApp, "available!")
                }
            }
            selectionAlert.addAction(action);
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
            ()
        }
        selectionAlert.addAction(cancelAction)
    }
    
    func isAppAvailable(_ routingApp: String)->Bool {
        return routingApps[routingApp] != nil && UIApplication.shared.canOpenURL(URL(string: routingApps[routingApp]!.replacingOccurrences(of: "%", with: ""))!)
    }
    
    private func validateForURL(_ text: String?)->String {
        if text == nil || text!.isEmpty {
            return ""
        } else {
            return text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
    }
    
    func getAppURLForAddress(_ routingApp: String, name: String, house: String, street: String, zip: String, city: String, country: String, lat: CGFloat, lon: CGFloat)->URL? {
        return getAppURLForAddress(
            routingApp,
            name: validateForURL(name),
            house: validateForURL(house),
            street: validateForURL(street),
            zip: validateForURL(zip),
            city: validateForURL(city),
            country: validateForURL(country),
            countryAlpha3: validateForURL(CountryAlpha3Converter.getAlpha3ForCountry(country)),
            lat: lat,
            lon: lon)
    }
    
    private func getAppURLForAddress(_ routingApp: String, name: String, house: String, street: String, zip: String, city: String, country: String, countryAlpha3: String, lat: CGFloat, lon: CGFloat)->URL? {
        if routingApps[routingApp] == nil {
            return nil
        } else {
            let appURL = routingApps[routingApp]!
                .replacingOccurrences(of: "%name%", with: name)
                .replacingOccurrences(of: "%house%", with: house)
                .replacingOccurrences(of: "%street%", with: street)
                .replacingOccurrences(of: "%zip%", with: zip)
                .replacingOccurrences(of: "%city%", with: city)
                .replacingOccurrences(of: "%country%", with: country)
                .replacingOccurrences(of: "%country-a3%", with: countryAlpha3)
                .replacingOccurrences(of: "%lat%", with: String(describing: lat))
                .replacingOccurrences(of: "%lon%", with: String(describing: lon))
            
            return URL(string: appURL)
        }
    }
    
    private func generateURLsForAddress(_ name: String, house: String, street: String, zip: String, city: String, country: String, countryAlpha3: String, lat: CGFloat, lon: CGFloat) {
        currentURLs = [:]
        for routingApp in routingApps.keys {
            currentURLs[routingApp] = getAppURLForAddress(routingApp, name: name, house: house, street: street, zip: zip, city: city, country: country, countryAlpha3: countryAlpha3, lat: lat, lon: lon)
        }
    }
    
    func getAlertForAddress(_ name: String, house: String, street: String, zip: String, city: String, country: String, lat: CGFloat, lon: CGFloat)->UIAlertController {
        generateURLsForAddress(
            validateForURL(name),
            house: validateForURL(house),
            street: validateForURL(street),
            zip: validateForURL(zip),
            city: validateForURL(city),
            country: validateForURL(country),
            countryAlpha3: validateForURL(CountryAlpha3Converter.getAlpha3ForCountry(country)),
            lat: lat,
            lon: lon)
        return selectionAlert
    }
}
