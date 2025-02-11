#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_upshot_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_upshot_plugin'
  s.version          = '1.0.0'
  s.summary          = 'Upshot.ai User Engagement SDK for iOS'
  s.description      = <<-DESC
                      Upshot.ai is a analytics and customer engagement platform. This framework helps you capture analytics, track events, send smart notifications and in-app messages to users.
                       DESC
  s.homepage         = 'http://upshot.ai/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Upshot' => 'developer@upshot.ai'  }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Upshot'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.swift_version = '5.0'
  s.pod_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
