require 'spec_helper'

describe 'pdns::service', :type => :class do

  it { should create_class('pdns::service') }
  it { should contain_service('pdns').with_ensure('running').with_enable('true') }
  it { should contain_service('pdns-recursor').with_ensure('running').with_enable('true') }

end

