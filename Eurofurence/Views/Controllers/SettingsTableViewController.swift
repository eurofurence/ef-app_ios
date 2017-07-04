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
        form +++ Section("Network")
            <<< SwitchRow("switchRowUpdateOnStart") { row in      // initializer
                row.title = "Automaticaly update on start"
                row.value = UserSettings.UpdateOnStart.currentValue()
                }.onChange { row in
                    UserSettings.UpdateOnStart.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< SwitchRow("SwitchRow") { row in      // initializer
                row.title = "Auto-update on mobile"
                row.value = UserSettings.AutomaticRefreshOnMobile.currentValue()
                }.onChange { row in
                    UserSettings.AutomaticRefreshOnMobile.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< PushRow<Int>("pushRowRefreshTimer") { row in      // initializer
                row.title = "Refresh interval"
                
                row.displayValueFor = { value in
                    var minutes = -1
                    
                    if let value = value {
                        minutes = Int(value/60)
                        if value <= 0 {
                            return "Never"
                        }
                    }
                    if minutes == 1 {
                        return "every 1 minute"
                    } else {
                        return "every " + String(minutes) + " minutes"
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

            <<< SwitchRow("switchRowNotifyOnAnnouncement") { row in      // initializer
                row.title = "Notify on new announcements"
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
            +++ Section("Data Storage")
            <<< ButtonRow(){
                $0.title = "Download database"
                }.onCellSelection { row in
					// TODO: Perform sync without since
                    /*ApiManager.sharedInstance.updateAllEntities(true, completion: nil)*/
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< ButtonRow(){
                $0.title = "Clear database & cache"
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
            +++ Section(header:"Experimental features", footer: "Allowing the app to try refreshing in background will only consume a small amount of data. This allows us to keep you updated on the latest announcements regarding delays and other important events at the con. Please note that background refreshing may not always work and can be unreliable!")
            <<< SwitchRow("switchRowRefreshInBackground") { row in      // initializer
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
            <<< SwitchRow("switchRowRefreshInBackgroundOnMobile") { row in      // initializer
                row.title = "Background refresh on mobile"
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
			+++ Section(header:"Debugging", footer: "These settings are intended for debugging purposes only and may cause instability or unexpected behaviour if changed!")
			<<< TimeIntervalRow("timeIntervalRowTimeOffset") { row in      // initializer
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
        // Do any additional setup after loading the view.
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
    /*
     // MARK: - Navigation
	
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func openMenu(_ sender: AnyObject) {
        showApp();
    }
    
    func showApp() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        self.slideMenuController()?.changeMainViewController(rootVC, close: true)
    }
}
