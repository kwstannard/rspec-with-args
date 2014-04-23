module RSpec::WithArgs::InstanceMethodExampleGroup
  extend RSpec::WithArgs::CommonClassMethods
  include RSpec::WithArgs::CommonInstanceMethods

  RSpec.configure do |c|
    c.include self, {with_args:
      lambda do |a, m|
      descriptee(m).to_s.match(instance_regex)
      end
    }
  end

  def self.included(base)
    set_subject_method_proc(base.metadata)
    set_subject_method_name(base.metadata)

    base.subject do
      callee
    end
  end

  def self.set_subject_method_proc(metadata)
    metadata[:subject_method_proc] = proc do |x|
      x.send(
        subject_method_name,
        *subject_args.map{|a| send(a)}
      )
    end
  end

  def self.set_subject_method_name(metadata)
    case d = metadata[:example_group][:description_args].first
    when is_a?(Class)
      metadata[:subject_method_name] = d
    when instance_regex
      metadata[:subject_method_name] = d.gsub instance_regex, ""
    end
  end

  def self.instance_regex
    /^#/
  end

  def callee
    instance_exec parent_callee, &subject_method_proc
  end

  def parent_callee
    instance_eval &metadata[:subject_class_proc]
  end

  def subject_method_proc
    metadata[:subject_method_proc]
  end

  def subject_method_name
    metadata[:subject_method_name]
  end
end
