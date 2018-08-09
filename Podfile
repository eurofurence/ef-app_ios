# Dependency management for the Eurofurence app
platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'Eurofurence' do
	plugin 'cocoapods-acknowledgements', :settings_bundle => true
	
	pod 'Down'
	pod 'SwiftLint'
	pod 'ReachabilitySwift'
	pod 'Firebase/Core'
	pod 'Firebase/Crash'
	pod 'Firebase/Messaging'
	pod 'Firebase/Performance'
	pod 'Locksmith'
	
	pod 'SimulatorStatusMagic', :configurations => ['Screenshots']

	target :EurofurenceTests do
		inherit! :search_paths

		pod 'Firebase/Core'
		pod 'Firebase/Crash'
	end
	
	post_install do |installer|
		installer.pods_project.targets.each do |target|
			if target.name == "Eureka" || target.name == "Down"
				target.build_configurations.each do |config|
					config.build_settings['SWIFT_VERSION'] = '4.1'
				end
			else
				target.build_configurations.each do |config|
					config.build_settings['SWIFT_VERSION'] = '3.0'
				end
			end
		end
	end
	
end
