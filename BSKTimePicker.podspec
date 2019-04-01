#
# Be sure to run `pod lib lint BSKTimePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BSKTimePicker'
  s.version          = '0.1.0'
  s.summary          = 'An iOS UI component to pick accurate time within one day.'
  s.description      = 'A UI component to pick accurate time within one day, which also enabled with zoom function to quickly switch hour to second'
  s.homepage         = 'https://github.com/BossKinKa/BSKTimePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BossKinKa' => 'BossKinKa@gmail.com' }
  s.source           = { :git => 'https://github.com/BossKinKa/BSKTimePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '8.0'
  s.source_files = 'BSKTimePicker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BSKTimePicker' => ['BSKTimePicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Masonry'
end
