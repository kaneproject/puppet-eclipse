require 'spec_helper'
describe 'eclipse' do

  context 'with defaults for all parameters' do
    it { should contain_class('eclipse') }
  end
end
