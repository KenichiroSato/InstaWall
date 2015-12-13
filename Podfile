platform :ios, '8.0'
use_frameworks!
xcodeproj './instawallpaper.xcodeproj'

pod 'InstagramKit', '3.6.3'
pod 'HMSegmentedControl'
pod 'SDWebImage', '~>3.7'

pod 'Fabric'
pod 'Crashlytics'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'instawallpaper/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end