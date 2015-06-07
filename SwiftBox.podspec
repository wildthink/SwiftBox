Pod::Spec.new do |s|

  s.name = 'SwiftBox'
  s.version = '0.1'
  s.license = 'MIT'
  s.summary = 'Common Code in Swift'
  s.homepage = 'https://github.com/wildthink/SwiftBox'
  s.social_media_url = 'http://twitter.com/jasonj_2009'
  s.authors = { 'Jason Jobe' => '' }
  s.source = { :git => 'https://github.com/wildthink/SwiftBox.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'SwiftBox/*.swift'

  s.requires_arc = true

end