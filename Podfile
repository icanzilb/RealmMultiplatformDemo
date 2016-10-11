use_frameworks!

abstract_target 'RealmTasks' do

    pod 'RealmSwift', '~> 2.0.0'

	target 'RealmShowcase-OSX' do
		platform :osx, '10.10'
	end
	
	target 'RealmShowcase-iOS' do
		platform :ios, '8.0'
	end
	
	target 'RealmShowcase-tvOS' do
	    platform :tvos, '9.1'
	end
	
	target 'RealmShowcase-watchOS Extension' do
	    platform :watchos, '2.0'
	end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end
