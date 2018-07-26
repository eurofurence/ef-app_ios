# Dependency management for the Eurofurence app
platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'Eurofurence' do
	plugin 'cocoapods-acknowledgements', :settings_bundle => true
	
	pod 'Alamofire', '~> 4.5'
	pod 'AlamofireImage', '~> 3.0'
	pod 'Changeset'
	pod 'Dip', :git => 'https://github.com/AliSoftware/Dip.git', :branch => 'swift42'
	pod 'Eureka'
	pod 'EVReflection'
	pod 'EVReflection/Alamofire'
	pod 'SwiftLint'
	pod 'ReachabilitySwift'
	pod 'ReactiveSwift', '~> 1.1'
	pod 'ReactiveCocoa', '~> 5.0.0'
	pod 'Firebase/Core'
	pod 'Firebase/Crash'
	pod 'Firebase/Messaging'
	pod 'Firebase/Performance'
	pod 'Locksmith'
	pod 'Whisper'
	
	pod 'SimulatorStatusMagic', :configurations => ['Screenshots']

	target :EurofurenceTests do
		inherit! :search_paths

		pod 'Firebase/Core'
		pod 'Firebase/Crash'
	end
	
	post_install do |installer|
		installer.pods_project.targets.each do |target|
			if target.name == "Eureka"
				target.build_configurations.each do |config|
					config.build_settings['SWIFT_VERSION'] = '4.1'
				end
			end
		end
	end
	
end
