require 'spec_helper'
describe 'emsa_downsampling' do

  context 'with defaults for all parameters' do
    it { should contain_class('emsa_downsampling') }
  end
end
