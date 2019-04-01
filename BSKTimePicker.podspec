Pod::Spec.new do |s|
  s.name             = 'BSKTimePicker'
  s.version          = '0.1.0'
  s.summary          = 'An iOS UI component to pick accurate time within one day.'
  s.description      = 'A UI component to pick accurate time within one day, which also enabled with zoom function to quickly switch hour to second.'
  s.homepage         = 'https://github.com/BossKinKa/BSKTimePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BossKinKa' => 'BossKinKa@gmail.com' }
  s.source           = { :git => 'https://github.com/BossKinKa/BSKTimePicker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'BSKTimePicker/Classes/**/*'
  s.dependency 'Masonry'
end
