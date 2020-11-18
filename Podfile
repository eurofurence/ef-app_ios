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

target :EurofurenceApplicationSession do
  project 'Eurofurence.xcodeproj'
  
  pod 'FirebaseCore'
  pod 'FirebaseMessaging'
  pod 'FirebaseRemoteConfig'
  
  target :EurofurenceApplicationSessionTests do
    inherit! :search_paths
  end
end

post_install do |pi|
    pi.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end
