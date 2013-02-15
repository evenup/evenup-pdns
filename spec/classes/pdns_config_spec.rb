require 'spec_helper'

describe 'pdns::config', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  it { should create_class('pdns::config') }

  it { should contain_file('/etc/pdns').with_ensure('directory') }
  it { should contain_file('/etc/pdns/zones').with_ensure('directory') }
  it { should contain_file('/etc/pdns-recursor').with_ensure('directory') }
  it { should contain_file('/etc/pdns/pdns.conf').with_notify('Class[Pdns::Service]') }
  it { should contain_file('/etc/pdns/puppetdb.yaml').with_notify('Class[Pdns::Service]') }
  it { should contain_file('/etc/pdns-recursor/recursor.conf').with_notify('Class[Pdns::Service]') }
  it { should contain_concat('/etc/named.conf') }

end

