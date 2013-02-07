require 'spec_helper'

describe 'pdns::zone', :type => :define do
  let(:title) { 'test.com' }
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  context "when present" do
    let(:params) { { :source => 'puppet:///data/test.com' } }
    it { should contain_file('/etc/pdns/zones/test.com.zone')}
    it { should contain_concat__fragment('test.com_zone') }
  end

  context "when absent" do
    let(:params) { { :ensure => 'absent', :source => 'puppet:///data/test.com' } }
    it { should contain_file('/etc/pdns/zones/test.com.zone').with_ensure('absent') }
    it { should contain_concat__fragment('test.com_zone').with_ensure('absent') }
  end

end
