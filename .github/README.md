# device-farm

[![CircleCI](https://circleci.com/gh/viniciusmo/device-farm.svg?style=shield)](https://circleci.com/gh/viniciusmo/device-farm)
[![Gem](https://img.shields.io/gem/v/devicefarm.svg?style=flat)](http://rubygems.org/gems/devicefarm "View this project in Rubygems")

A simple way to upload your artifacts to test your app in AWS Device Farm


## Usage
```ruby
require "devicefarm"

ENV['AWS_ACCESS_KEY_ID']     = 'xxxxx'
ENV['AWS_SECRET_ACCESS_KEY'] = 'xxxxx'
ENV['AWS_REGION']            = 'us-west-2'
  
DeviceFarm.test_with_calabash(
	project_name:"best-project",
	device_pool_name: "top-devices-google-play",
	binary_path:"best-app.apk",
	calabash_test_package_path:"calabash_features.zip")
```

## Installation

```ruby
gem install "devicefarm"
```

## Author

viniciusmo

## License

This project is available under the MIT license. See the LICENSE file for more info.

