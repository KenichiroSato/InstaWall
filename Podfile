pod 'InstagramKit', '3.6.3'
pod 'HMSegmentedControl'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'instawallpaper/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end