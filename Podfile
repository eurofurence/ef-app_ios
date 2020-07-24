platform :ios, '11.1'
inhibit_all_warnings!
use_frameworks!
workspace 'Eurofurence.xcworkspace'

target :Eurofurence do
  project 'Eurofurence.xcodeproj'
  plugin 'cocoapods-acknowledgements', :settings_bundle => true
  
  pod 'Down'
  pod 'FirebaseCore'
  pod 'FirebaseCrashlytics'
  pod 'FirebaseMessaging'
  pod 'FirebaseRemoteConfig'
    
  target :EurofurenceTests do
    inherit! :search_paths
  end
  
  target :Screenshots
  
end
