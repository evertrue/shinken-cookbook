source 'https://supermarket.chef.io'
source 'https://berks.evertrue.com'

metadata

group :integration do
  cookbook 'mock-ec2', path: './test/cookbooks/mock-ec2'
  cookbook 'test-tools', path: './test/cookbooks/test-tools'
  cookbook 'test-data', path: './test/cookbooks/test-data'
  cookbook 'et_hostname'
  cookbook 'ec2dnsserver'
end
