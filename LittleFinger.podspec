#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LittleFinger'
  s.version          = '0.1.0'
  s.summary          = 'iOS Library for Little Finger'

  s.description      = s.summary

  s.homepage         = 'http://avi.im/little-finger'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Avinash Sajjanshetty' => 'hi@avi.im' }
  s.source           = { :git => 'https://github.com/avinassh/little-finger-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/iavins'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LittleFinger/*.swift'
end
