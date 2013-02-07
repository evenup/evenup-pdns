require 'spec_helper'

describe 'pdns', :type => :class do
  let(:facts) { { :concat_basedir => '/var/lib/puppet/concat' } }

  it { should create_class('pdns') }

end

