# -*- coding: UTF-8 -*-
# Make our libraries available for testing, Chef does this for us
# in a real convergence.
$LOAD_PATH << 'libraries'

# Pull in commonly used libraries
require 'chefspec'

begin
  require 'safe_yaml'

  # This option prevents SafeYAML from complaining in `load`.
  SafeYAML::OPTIONS[:default_mode] = :safe

  # This is a workaround to https://github.com/dtao/safe_yaml/issues/10
  SafeYAML::OPTIONS[:deserialize_symbols] = true
rescue LoadError
  puts 'Failed to configure SafeYAML, you may see some warnings.'
end

# ChefSpec sets up the Chef cookbook_path so that it includes the
# vendor/cookbooks directory.  We need to tell Berkshelf to install
# our dependencies there.
begin
  require 'berkshelf'
  berks = ::Berkshelf::Berksfile.from_file 'Berksfile'
  RSpec.configure do |config|
    config.before(:suite) do
      FileUtils.rm_rf 'vendor/cookbooks'
      berks.install(path: 'vendor/cookbooks')
    end
    config.after(:suite) do
      FileUtils.rm_rf 'vendor/cookbooks'
    end
  end
rescue LoadError
  puts 'Failed to configure Berkshelf, cookbooks may be out of date.'
end
