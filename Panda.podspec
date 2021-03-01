Pod::Spec.new do |s|
  s.name = 'Panda'
  s.version = '0.0.4'
  s.license = 'MIT'
  s.summary = 'macos/ios 网路请求(Moya + ObjectMapper)'
  s.homepage = 'https://github.com/tyrad/Panda'
  s.authors = { 'MistJ' => 'tyradccc@gmail.com' }
  s.source = { :git => 'https://github.com/tyrad/Panda.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '3.0' 

  s.swift_version = '5.0'

  s.dependency "ObjectMapper", "4.1.0"
  s.dependency "Moya", "13.0.1"

  s.requires_arc = true
  s.source_files = 'Sources/**/*.swift'
end
