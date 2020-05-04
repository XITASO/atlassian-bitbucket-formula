require "serverspec"

set :backend, :exec

describe command('sleep 10s') do
  its(:exit_status) { should eq 0 }
end

describe service("atlassian-bitbucket") do
  it { should be_enabled }
  it { should be_running }
end

# Bitbucket
describe port("7990") do
  it { should be_listening }
end

# Elasticsearch
describe port("7992") do
  it { should be_listening }
end

describe command('curl -L localhost:7990') do
  its(:stdout) { should contain('Bitbucket') }
end
