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
	private var versionTapCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        makeNetworkSection()
        makePushNotificationsSection()
		makeFavoriteEventsSection()
        makeDataStorageSection()
		makeFCMSection()
		makeDebuggingSettingsSection()
    }

    private func makeNetworkSection() {
        form +++ Section("Network")
            <<< SwitchRow("UpdateOnStart") { row in
                row.title = "Update on Launch"
				row.value = UserSettings.UpdateOnStart.currentValue()
                }.onChange { row in
                    UserSettings.UpdateOnStart.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
            <<< SwitchRow("UpdateOnMobile") { row in
                row.title = "Auto-Update on Mobile"
				row.value = UserSettings.AutomaticRefreshOnMobile.currentValue()
				//TODO: Remove once this setting has actually been implemented properly
				row.hidden = true
                }.onChange { row in
                    UserSettings.AutomaticRefreshOnMobile.setValue(row.value!)
                    row.updateCell()
                }.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            }
	}

	private func makePushNotificationsSection() {
		let defaults = UserDefaults.standard
		let witnessedSystemPushRequest = UserDefaultsWitnessedSystemPushPermissionsRequest(userDefaults: defaults)

		let section = Section("Push Notifications")
		section <<< ButtonRow {
			$0.title = "Enable Push Notifications"
			if witnessedSystemPushRequest.witnessedSystemPushPermissionsRequest {
				//TODO: Remove once we re-enable or add new settings to this section
				section.hidden = true
				$0.hidden = true
			}

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
			<<< SwitchRow("NotifyOnAnnouncement") { row in
				row.title = "Notify on New Announcements"
				row.value = UserSettings.NotifyOnAnnouncement.currentValue()
				//TODO: Remove once this setting has actually been implemented properly
				row.hidden = true
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

		form +++ section
	}

	private func makeFavoriteEventsSection() {
		let eventNotificationPreferences = UserDefaultsEventNotificationPreferences.instance

		form +++ Section("Favorite Events")
			<<< SwitchRow("FavoriteEventsNotify") {
				$0.title = "Notify before Favorite Events"
				$0.value = eventNotificationPreferences.notificationsEnabled
				}.onChange({ (row) in
					if let value = row.value {
						eventNotificationPreferences.setNotificationsEnabled(value)
					}
				})

			<<< TimeIntervalRow("FavoriteEventsNotifyAheadInterval") {
				$0.title = "Time of Notification"
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
				}.onCellSelection { _ in
					self.versionTapCount += 1
					if let showDebugSettingsRow = self.form.rowBy(tag: "ShowDebugSettings") as? SwitchRow,
						self.versionTapCount == 7 && !(showDebugSettingsRow.value ?? true) {

						UserSettings.DebugSettingsEnabled.setValue(true)
						showDebugSettingsRow.value = true
					}
				}.cellUpdate { cell, _ in
                    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        }
    }

    private func makeFCMSection() {
		form +++ Section("FCM Token") {
			$0.hidden = Condition.function(["ShowDebugSettings"], { form in
				return !(((form.rowBy(tag: "ShowDebugSettings") as? SwitchRow)?.value ?? false) ||
					UserSettings.DebugSettingsEnabled.currentValueOrDefault() as Bool)
			})
			}
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
		form +++ Section(header:"Debugging", footer: "These settings are intended for debugging purposes only and may cause instability or unexpected behaviour if changed!") {
			$0.hidden = Condition.function(["ShowDebugSettings"], { form in
				return !(((form.rowBy(tag: "ShowDebugSettings") as? SwitchRow)?.value ?? false) ||
					UserSettings.DebugSettingsEnabled.currentValueOrDefault() as Bool)
			})
			}
			<<< SwitchRow("ShowDebugSettings") {
				$0.title = "Show Debug Settings"
				$0.value = UserSettings.DebugSettingsEnabled.currentValueOrDefault()
				}.onChange({ (row) in
					if let value = row.value {
						if !value {
							self.versionTapCount = 0
						}
						UserSettings.DebugSettingsEnabled.setValue(value)
					}
				})
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
