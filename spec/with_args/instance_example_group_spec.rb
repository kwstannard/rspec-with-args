require 'with_args'

class InitializationArgs < Struct.new(:foo)
  def method_with_no_args
    'hi'
  end
end

describe InitializationArgs, with_args: [:foo] do
  let(:foo) { 'foo' }
  describe '#method_with_no_args' do
    it { should eq 'hi' }
  end
end
