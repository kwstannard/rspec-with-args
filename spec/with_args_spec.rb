require_relative 'support/example_groups/with_args'

class Foo < Struct.new(:arg1, :arg2)
  def foo(m_arg1)
    m_arg1 + arg1
  end

  def self.class_method(c_arg1, c_arg2)
    c_arg1 + c_arg2
  end
end

describe Foo, with_args: [:bar, :baz] do
  let(:bar) { "bar" }
  let(:baz) { "baz" }

  context "subject initialization" do
    it { should eq(Foo.new(bar, baz)) }

    context "with changed arguments" do
      let(:bar) { "bee" }
      let(:baz) { "boo" }

      it { should eq(Foo.new(bar, baz)) }
    end
  end

  context "explicitly setting the subject" do
    subject { described_class.new(fuu) }
    let(:fuu) { "fuu" }

    it "overrides with-args default subject" do
      subject.arg1.should eq(fuu)
    end
  end

  context "method arguments" do
    describe "#foo", with_args: [:zoo] do
      let(:zoo) { "zoo" }
      context "has access to initialization arguments" do
        it { should eq(zoo + bar) }
      end

      context "with changed arguments" do
        let(:zoo) { "zuu" }
        let(:bar) { "baar" }

        it { should eq(zoo + bar) }
      end
    end
  end

  context "class method arguments" do
    describe ".class_method", with_args: [:zoo, :bar] do
      let(:zoo) { "zoo" }
      let(:bar) { "bar" }

      it { should eq(zoo + bar) }

      context "with changed arguments" do
        let(:zoo) { "zuu" }
        let(:bar) { "baar" }

        it { should eq(zoo + bar) }
      end
    end
  end
end
