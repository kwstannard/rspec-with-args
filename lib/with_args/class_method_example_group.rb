module RSpec::WithArgs::ClassMethodExampleGroup
  extend RSpec::WithArgs::CommonClassMethods
  include RSpec::WithArgs::CommonInstanceMethods
  RSpec.configure do |c|
    c.include self, {with_args:
      lambda do |a, m|
      descriptee(m).to_s.match(/^\./)
      end
    }
  end

  def self.included(base)
    set_subject_proc(base.metadata)
    set_subject_method_name(base.metadata)

    base.subject do
      instance_eval &subject_proc
    end
  end

  def self.set_subject_proc(metadata)
    metadata[:subject_proc] = proc do |x|
      described_class.send(
        subject_method_name,
        *subject_args.map{|a| send(a)}
      )
    end
  end

  def self.set_subject_method_name(metadata)
    case d = metadata[:example_group][:description_args].first
    when is_a?(Class)
      metadata[:subject_method_name] = d
    when /^[.#]/
      metadata[:subject_method_name] = d.gsub /^[.#]/, ""
    end
  end

  def subject_proc
    metadata[:subject_proc]
  end

  def subject_method_name
    metadata[:subject_method_name]
  end
end
