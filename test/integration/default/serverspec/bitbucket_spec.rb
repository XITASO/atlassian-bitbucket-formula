require "serverspec"

set :backend, :exec

describe service("atlassian-bitbucket") do
  it { should be_enabled }
  it { should be_running }
end

describe port("7990") do
  it { should be_listening }
end

describe command('curl -L localhost:7990') do
  its(:stdout) { should contain('Bitbucket') }
end
