//
//  SettingsTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Eureka

class SettingsTableViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        makeNetworkSection()
        makeDataStorageSection()
        makeExperimentalFeaturesSection()
        #if DEBUG
            makeDebuggingSettingsSection()
        #endif
    }

    private func makeNetworkSection() {
        form +++ Section("Network")
            <<< SwitchRow("switchRowUpdateOnStart") { row in
                row.title = "Auto-Update on Launch"
                row.value = UserSettings.UpdateOnStart.currentValue()
                }.onChange { row in
                    UserSettings.UpdateOnStart.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< SwitchRow("SwitchRow") { row in
                row.title = "Auto-Update on Mobile"
                row.value = UserSettings.AutomaticRefreshOnMobile.currentValue()
                }.onChange { row in
                    UserSettings.AutomaticRefreshOnMobile.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< PushRow<Int>("pushRowRefreshTimer") { row in
                row.title = "Refresh Interval"

                row.displayValueFor = { value in
                    var minutes = -1

                    if let value = value {
                        minutes = Int(value/60)
                        if value <= 0 {
                            return "Never"
                        }
                    }
                    if minutes == 1 {
                        return "Every 1 Minute"
                    } else {
                        return "Every " + String(minutes) + " Minutes"
                    }
                }

                row.options = [-1, 300, 600, 900, 1800, 3600]

                row.value = UserSettings.RefreshTimer.currentValue()
                }.onChange { row in

                    // TODO: BUG! Label becomes empty when currently selected entry is selected again

                    var refreshSeconds: Int = UserSettings.RefreshTimer.currentValueOrDefault()
                    if let value = row.value {
                        refreshSeconds = value
                    } else {
                        row.value = refreshSeconds
                    }
                    UserSettings.RefreshTimer.setValue(refreshSeconds)
                    if refreshSeconds > 0 && UserSettings.RefreshInBackground.currentValueOrDefault() {
                        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
                    } else {
                        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
                    }
                    // TODO: Reimplement timed refresh (maybe X minutes after last push-triggered refresh?)
                    /*AutomaticRefresh.sharedInstance.updateTimer()*/
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }

            <<< SwitchRow("switchRowNotifyOnAnnouncement") { row in
                row.title = "Notify on New Announcements"
                row.value = UserSettings.NotifyOnAnnouncement.currentValue()
                row.hidden = Condition.function(["pushRowRefreshTimer"], { form in
                    let value = (form.rowBy(tag: "pushRowRefreshTimer") as? PushRow<Int>)?.value
                    return (value != nil) && value! <= 0
                })
                }.onChange { row in
                    if let value = row.value {
                        UserSettings.NotifyOnAnnouncement.setValue(value)
                        if !value {
                            (self.form.rowBy(tag: "switchRowRefreshInBackground") as? SwitchRow)?.value = false
                        }
                    }
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        }
    }

    private func makeDataStorageSection() {
        form +++ Section("Data Storage")
            <<< ButtonRow(){
                $0.title = "Download Database"
                }.onCellSelection { row in
                    // TODO: Perform sync without since
                    /*ApiManager.sharedInstance.updateAllEntities(true, completion: nil)*/
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< ButtonRow(){
                $0.title = "Clear Database and Cache"
                }.onCellSelection { row in
                    // TODO: Clear cache and storage
                    /*ApiManager.sharedInstance.clearCache()*/
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
                    cell.textLabel?.textColor = UIColor.red
            }
            +++ Section("Other")
            <<< LabelRow() { row in
                // TODO: VersionProvider?
                row.title = "Version: " /*+ ConfigManager.sharedInstance.appVersion*/
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        }
    }

    private func makeExperimentalFeaturesSection() {
        form +++ Section(header:"Experimental Features", footer: "Allowing the app to try refreshing in background will only consume a small amount of data. This allows us to keep you updated on the latest announcements regarding delays and other important events at the con. Please note that background refreshing may not always work and can be unreliable.")
            <<< SwitchRow("switchRowRefreshInBackground") { row in
                row.title = "Refresh in background"
                row.value = UserSettings.RefreshInBackground.currentValue()
                }.onChange { row in
                    if let value = row.value {
                        UserSettings.RefreshInBackground.setValue(value)
                        if value {
                            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
                        } else {
                            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
                        }
                        if value {
                            (self.form.rowBy(tag: "switchRowNotifyOnAnnouncement") as? SwitchRow)?.value = true
                        }
                    }
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                    cell.backgroundColor = UIColor.lightText
            }
            <<< SwitchRow("switchRowRefreshInBackgroundOnMobile") { row in
                row.title = "Background Refresh on Mobile"
                row.value = UserSettings.RefreshInBackgroundOnMobile.currentValue()
                row.hidden = Condition.function(["pushRowRefreshTimer", "switchRowRefreshInBackground"], { form in
                    return !((form.rowBy(tag: "switchRowNotifyOnAnnouncement") as? SwitchRow)?.value ?? true) || !((form.rowBy(tag: "switchRowRefreshInBackground") as? SwitchRow)?.value ?? true)
                })
                }.onChange { row in
                    UserSettings.RefreshInBackgroundOnMobile.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                    cell.backgroundColor = UIColor.lightText
        }
    }

    private func makeDebuggingSettingsSection() {
        form +++ Section(header:"Debugging", footer: "These settings are intended for debugging purposes only and may cause instability or unexpected behaviour if changed!")
            <<< TimeIntervalRow("timeIntervalRowTimeOffset") { row in
                row.title = "Time Offset"
                row.value = UserSettings.DebugTimeOffset.currentValue()
                }.onChange { row in
                    if let value = row.value {
                        UserSettings.DebugTimeOffset.setValue(value)
                    }
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                    cell.backgroundColor = UIColor.lightText
        }
    }

    @IBAction func openMenu(_ sender: AnyObject) {
        showApp();
    }

    func showApp() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        self.slideMenuController()?.changeMainViewController(rootVC, close: true)
    }
}
