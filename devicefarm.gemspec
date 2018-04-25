Gem::Specification.new do |s|
  s.name        = 'devicefarm'
  s.version     = '0.0.14'
  s.date        = '2018-04-19'
  s.summary     = "Device Farm"
  s.description = "A simple way to upload your artifacts to test your app ;)"
  s.authors     = ["viniciusmo"]
  s.email       = 'viniciusoliveiravmo@gmail.com'
  s.files       = ["lib/devicefarm.rb", "lib/devicefarm/devicefarmapi.rb"]
  s.homepage    =
    'http://rubygems.org/gems/devicefarm'
  s.license       = 'MIT'
  s.add_dependency('aws-sdk-devicefarm', '1.5.0')
  
end