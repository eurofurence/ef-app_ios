//
//  SettingsTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Eureka
import FirebaseMessaging
import MobileCoreServices
import UIKit

class SettingsTableViewController: FormViewController {

	private let contextManager: ContextManager = try! ContextResolver.container.resolve()
	private let imageService: ImageServiceProtocol = try! ServiceResolver.container.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeNetworkSection()
        makePushNotificationsSection()
		makeFavoriteEventsSection()
        makeDataStorageSection()
        makeExperimentalFeaturesSection()
        #if DEBUG
            makeFCMSection()
            makeDebuggingSettingsSection()
        #endif
    }

    private func makeNetworkSection() {
        form +++ Section("Network")
            <<< SwitchRow("UpdateOnStart") { row in
                row.title = "Auto-Update on Launch"
				row.value = UserSettings.UpdateOnStart.currentValue()
				row.disabled = true
                }.onChange { row in
                    UserSettings.UpdateOnStart.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< SwitchRow("UpdateOnMobile") { row in
                row.title = "Auto-Update on Mobile"
				row.value = UserSettings.AutomaticRefreshOnMobile.currentValue()
				row.disabled = true
                }.onChange { row in
                    UserSettings.AutomaticRefreshOnMobile.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< PushRow<Int>("RefreshTimer") { row in
                row.title = "Refresh Interval"
				row.displayValueFor = { value in
                    var minutes = -1

                    if let value = value {
                        minutes = Int(value/60)
					}
					if minutes <= 0 {
						return "Never"
					} else if minutes == 1 {
                        return "Every 1 Minute"
                    } else {
                        return "Every " + String(minutes) + " Minutes"
                    }
                }
                row.options = [-1, 300, 600, 900, 1800, 3600]

				row.value = UserSettings.RefreshTimer.currentValue()
				row.disabled = true
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
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }

            <<< SwitchRow("NotifyOnAnnouncement") { row in
                row.title = "Notify on New Announcements"
                row.value = UserSettings.NotifyOnAnnouncement.currentValue()
				row.disabled = true
                row.hidden = Condition.function(["RefreshTimer"], { form in
                    let value = (form.rowBy(tag: "RefreshTimer") as? PushRow<Int>)?.value
                    return (value != nil) && value! <= 0
                })
                }.onChange { row in
                    if let value = row.value {
                        UserSettings.NotifyOnAnnouncement.setValue(value)
                        if !value {
                            (self.form.rowBy(tag: "RefreshInBackground") as? SwitchRow)?.value = false
                        }
                    }
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        }
	}

	private func makePushNotificationsSection() {
		let defaults = UserDefaults.standard
		let witnessedSystemPushRequest = UserDefaultsWitnessedSystemPushPermissionsRequest(userDefaults: defaults)
		guard !witnessedSystemPushRequest.witnessedSystemPushPermissionsRequest else { return }

		let section = Section("Push Notifications")
		section <<< ButtonRow {
			$0.title = "Enable Push Notifications"
			}.onCellSelection({ (_, _) in
				if witnessedSystemPushRequest.witnessedSystemPushPermissionsRequest {
					let alert = UIAlertController(title: "Use Settings",
					                              message: "Enable or disable Eurofurence's push notification permissions in Settings",
					                              preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK", style: .cancel))
					self.present(alert, animated: true)
				} else {
					ApplicationPushPermissionsRequesting().requestPushPermissions { }
					witnessedSystemPushRequest.markWitnessedSystemPushPermissionsRequest()
					defaults.synchronize()
				}
			})

		form +++ section
	}

	private func makeFavoriteEventsSection() {
		let eventNotificationPreferences = UserDefaultsEventNotificationPreferences.instance

		form +++ Section("Favorite Events")
			<<< SwitchRow("FavoriteEventsNotify") {
				$0.title = "Enable Favorite Event Notifications"
				$0.value = eventNotificationPreferences.notificationsEnabled
				}.onChange({ (row) in
					if let value = row.value {
						eventNotificationPreferences.setNotificationsEnabled(value)
					}
				})

			<<< TimeIntervalRow("FavoriteEventsNotifyAheadInterval") {
				$0.title = "Notify Ahead of Favorite Events"
				$0.noValueDisplayText = "on Start"
				$0.value = eventNotificationPreferences.notificationAheadInterval
				$0.hidden = Condition.function(["FavoriteEventsNotify"], { (form) -> Bool in
					return !((form.rowBy(tag: "FavoriteEventsNotify") as? SwitchRow)?.value ?? false)
				})
				}.onChange({ (row) in
					if let timeInterval = row.value {
						eventNotificationPreferences.setNotificationAheadInterval(timeInterval)
					}
				})
	}

    private func makeDataStorageSection() {
        form +++ Section("Data Storage")
            <<< ButtonRow {
                $0.title = "Force Full Synchronisation"
                }.onCellSelection { _ in
					// TODO: Provide feedback about background operations
					let confirmationAlert = UIAlertController(title: "Force Full Synchronisation", message: "All data and all images missing from cache will be downloaded from the server.", preferredStyle: UIAlertControllerStyle.alert)
					confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_: UIAlertAction!) in
						DataStoreRefreshController.shared.refreshStore(withDelta: false)
					}))
					confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
					self.present(confirmationAlert, animated: true, completion: nil)

                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
			}
			<<< ButtonRow {
				$0.title = "Clear Storage and Cache"
				}.onCellSelection { _ in
					// TODO: Provide feedback about background operations
					// TODO: Segue to start screen, asking the user to confirm inital sync
					let confirmationAlert = UIAlertController(title: "Clear Storage and Cache", message: "All offline data will be deleted and must be downloaded again afterwards, before the app can be used again!", preferredStyle: UIAlertControllerStyle.alert)
					confirmationAlert.addAction(UIAlertAction(title: "Clear All", style: .destructive, handler: { (_: UIAlertAction!) in
						self.contextManager.clearAll()

                        // TODO: Perform this resetting of tutorial flag/transition inside presentation tier
                        let tutorialFinishedKey = UserDefaultsTutorialStateProvider.FinishedTutorialKey
                        UserDefaults.standard.set(false, forKey: tutorialFinishedKey)
                        UserDefaults.standard.synchronize()

                        let window = UIApplication.shared.delegate!.window!
                        PresentationTier.assemble(window: window!)
					}))
					confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
					self.present(confirmationAlert, animated: true, completion: nil)
				}.cellUpdate { cell, _ in
					cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
					cell.textLabel?.textColor = UIColor.red
			}
			<<< ButtonRow {
				$0.title = "Clear Image Cache"
				}.onCellSelection { _ in
					// TODO: Provide feedback about background operations
					let confirmationAlert = UIAlertController(title: "Clear Image Cache", message: "All cached images will be deleted and must be downloaded again!", preferredStyle: UIAlertControllerStyle.alert)
					confirmationAlert.addAction(UIAlertAction(title: "Clear Cache", style: .destructive, handler: { (_: UIAlertAction!) in
						self.imageService.clearCache()
					}))
					confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
					self.present(confirmationAlert, animated: true, completion: nil)
				}.cellUpdate { cell, _ in
					cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
					cell.textLabel?.textColor = UIColor.red
			}
            +++ Section("Other")
            <<< LabelRow { row in
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
                row.title = "Version: \(version)"
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        }
    }

    private func makeExperimentalFeaturesSection() {
        form +++ Section(header:"Experimental Features", footer: "Allowing the app to try refreshing in background will only consume a small amount of data. This allows us to keep you updated on the latest announcements regarding delays and other important events at the con. Please note that background refreshing may not always work and can be unreliable.")
            <<< SwitchRow("RefreshInBackground") { row in
                row.title = "Refresh in background"
				row.value = UserSettings.RefreshInBackground.currentValue()
				row.disabled = true
                }.onChange { row in
                    if let value = row.value {
                        UserSettings.RefreshInBackground.setValue(value)
                        if value {
                            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
                        } else {
                            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
                        }
                        if value {
                            (self.form.rowBy(tag: "NotifyOnAnnouncement") as? SwitchRow)?.value = true
                        }
                    }
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                    cell.backgroundColor = UIColor.lightText
            }
            <<< SwitchRow("RefreshInBackgroundOnMobile") { row in
                row.title = "Background Refresh on Mobile"
				row.value = UserSettings.RefreshInBackgroundOnMobile.currentValue()
				row.disabled = true
                row.hidden = Condition.function(["RefreshTimer", "RefreshInBackground"], { form in
                    return !((form.rowBy(tag: "NotifyOnAnnouncement") as? SwitchRow)?.value ?? true) || !((form.rowBy(tag: "RefreshInBackground") as? SwitchRow)?.value ?? true)
                })
                }.onChange { row in
                    UserSettings.RefreshInBackgroundOnMobile.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                    cell.backgroundColor = UIColor.lightText
        }
    }

    private func makeFCMSection() {
        form +++ Section("FCM Token")
            <<< ButtonRow {
                $0.title = "Copy to Pasteboard"
                $0.onCellSelection({ (_, _) in
                    guard let value = Messaging.messaging().fcmToken else { return }
                    UIPasteboard.general.setValue(value, forPasteboardType: kUTTypeRTF as String)

                    let alert = UIAlertController(title: "FCM Copied",
                                                  message: "Send this to a developer if you'd like to receive a test notification",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
                })
            }
    }

    private func makeDebuggingSettingsSection() {
        form +++ Section(header:"Debugging", footer: "These settings are intended for debugging purposes only and may cause instability or unexpected behaviour if changed!")
            <<< TimeIntervalRow("TimeOffset") { row in
                row.title = "Time Offset"
				row.noValueDisplayText = "none"
                row.value = UserSettings.DebugTimeOffset.currentValue()
                }.onChange { row in
                    if let value = row.value {
                        UserSettings.DebugTimeOffset.setValue(value)
                    }
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                    cell.backgroundColor = UIColor.lightText
        }
    }
}
