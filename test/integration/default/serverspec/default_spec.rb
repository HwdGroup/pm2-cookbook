require 'serverspec'

# Required by serverspec
set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:$PATH'
  end
end

describe command('node --version') do
  its(:exit_status) { should eq 0 }
end

describe command('npm --version') do
  its(:exit_status) { should eq 0 }
end

describe command('pm2 --version') do
  its(:exit_status) { should eq 0 }
end

describe file('/etc/pm2/conf.d/test.json') do
  it { should be_file }
  it { should contain 'test.js' }
end

describe file('/etc/pm2/conf.d/test_w_user.json') do
  it { should be_file }
  it { should contain 'test_w_user.js' }
end

describe file('/home/nodeuser/.pm2') do
  it { should be_directory }
end

describe file('/home/nodeuserwithpm2home/.pm2/pm2.pid') do
  it { should be_file }
end

describe command('su root -c "pm2 info test"') do
  its(:stdout) { should contain 'online' }
end

describe command('su nodeuser -c "pm2 info test_w_user"') do
  its(:stdout) { should contain 'online' }
end

describe command('su nodeuserwithpm2home -c "pm2 info test_w_user_w_pm2_home"') do
  its(:stdout) { should contain 'online' }
end

describe command('ls /etc/rc3.d/S*pm2-init.sh') do
  its(:exit_status) { should eq 0 }
end

describe file('/etc/init.d/pm2-init.sh') do
  it { should be_file }
  it { should contain 'export PM2_HOME="/home/nodeuser/.pm2"' }
end
