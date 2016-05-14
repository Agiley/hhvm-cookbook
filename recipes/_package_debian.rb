include_recipe 'apt'

release = node['hhvm']['package']['debian_release'] || case node['platform_version'].to_f
when 7...8
    'wheezy'

when 12.04
    'precise'

when 13.1
    'saucy'

when 14.04
    'trusty'

when 14.10
    'utopic'

when 15.04
    'vivid'

when 15.10
    'wily'

when 16.04
    'xenial'

when 16.10
    'yakkety'

else
    raise %W(Platform not supported: #{node['platform_family']} (#{node[:platform]}) #{node['platform_version']}).join(' ')
end

apt_repository 'mapnik-boost' do
  uri 'http://ppa.launchpad.net/mapnik/boost/ubuntu'
  distribution release
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key '5D50B6BA'
  action :add
  only_if { node['lsb']['codename'] == 'precise' }
end

apt_repository 'hhvm' do
  uri          'http://dl.hhvm.com/'.concat(node[:platform].downcase)
  distribution release
  components   ['main']
  key          'http://dl.hhvm.com/conf/hhvm.gpg.key'
  only_if { node['platform_version'].to_f < 16.04 } # Xenial and above comes with packages for hhvm
end

if node['hhvm']['package']['type'] == :default || node['hhvm']['package']['type'] == 'default'
    package 'hhvm'
else
    package "hhvm-#{node['hhvm']['package']['type']}"
end
