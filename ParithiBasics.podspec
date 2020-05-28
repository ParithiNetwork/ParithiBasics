#
# Be sure to run `pod lib lint ParithiBasics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ParithiBasics'
  s.version          = '1.2.0'
  s.summary          = 'Basic Framework of iOS - Parithi Network'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'This framework is designed to create a basic framework for apps built at Parithi Network.'
                       DESC

  s.homepage         = 'https://github.com/ParithiNetwork/ParithiBasics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'parithi' => 'mail@parithi.com' }
  s.source           = { :git => 'https://github.com/ParithiNetwork/ParithiBasics.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/parithi'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Classes/**/*'
  s.swift_version = '5.0'
  
  s.platforms = {
      "ios" => "8.0"
  }
  # s.resource_bundles = {
  #   'ParithiBasics' => ['ParithiBasics/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
