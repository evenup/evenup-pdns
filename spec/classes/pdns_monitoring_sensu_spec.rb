require 'spec_helper'

describe 'pdns::monitoring::sensu', :type => :class do

  it { should create_class('pdns::monitoring::sensu') }
  it { should contain_sensu__check('pdns-recursor-running') }
  it { should contain_sensu__check('pdns-server-running') }

end
