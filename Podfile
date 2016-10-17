use_frameworks!

def shared_pods
    pod 'RealmSwift', '~> 2.0.0'
end

target 'RealmShowcase-OSX' do
    platform :osx, '10.10'
    shared_pods
end

target 'RealmShowcase-iOS' do
    platform :ios, '8.0'
    shared_pods
end

target 'RealmShowcase-tvOS' do
    platform :tvos, '9.1'
    shared_pods
end

target 'RealmShowcase-watchOS Extension' do
    platform :watchos, '2.0'
    shared_pods
end

# set targets to swift 3
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
