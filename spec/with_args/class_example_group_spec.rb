require_relative '../../lib/with_args/class_example_group'

class Comparator
  def ==(other)
    other.instance_variables == self.instance_variables
  end
end

class NoArgs < Comparator; end

describe NoArgs, :with_args do
  it { should eq(NoArgs.new) }
end

class OneArg < Comparator
  def initialize(foo); @foo = foo; end
end

describe OneArg, with_args: [:foo] do
  let(:foo) { "foo" }
  it { should eq(OneArg.new(foo)) }
end

class MultiArgs < Comparator
  def initialize(foo, bar); @foo,@bar = foo,bar; end
end

describe MultiArgs, with_args: [:foo, :bar] do
  let(:foo) { "foo" }
  let(:bar) { "bar" }
  it { should eq(MultiArgs.new(foo, bar)) }
end
