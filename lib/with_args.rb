module RSpec::WithArgs
  module CommonClassMethods
    def descriptee(m)
      m[:example_group][:description_args].first
    end
  end

  module CommonInstanceMethods
    def subject_args
      args = metadata.fetch(:with_args,[])
      if args.is_a?(Array)
        args
      else
        Array.new
      end
    end

    def metadata
      self.class.metadata
    end
  end

  module ClassExampleGroup
    extend CommonClassMethods
    include CommonInstanceMethods
    RSpec.configure do |c|
      c.include self, {with_args:
        proc do |a, m|
          descriptee(m).is_a?(Class)
        end
      }
    end

    def self.included(base)
      set_subject_class_proc(base.metadata)
      set_initialization_args(base.metadata)

      base.subject do
        instance_eval &subject_class_proc
      end
    end

    def self.set_subject_class_proc(metadata)
      metadata[:subject_class_proc] ||= proc do |x|
        described_class.new(*initialization_args.map{|a| send(a)})
      end
    end

    def self.set_initialization_args(metadata)
      metadata[:initialization_args] = metadata.fetch(:with_args,[])
    end

    def subject_class_proc
      metadata[:subject_class_proc]
    end

    def initialization_args
      args = metadata[:initialization_args]
      if args.is_a?(Array)
        args
      else
        Array.new
      end
    end
  end

  module ClassMethodExampleGroup
    extend CommonClassMethods
    include CommonInstanceMethods
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

  module InstanceMethodExampleGroup
    extend CommonClassMethods
    include CommonInstanceMethods
    RSpec.configure do |c|
      c.include self, {with_args:
        lambda do |a, m|
          descriptee(m).to_s.match(/^#/)
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
      when /^[.#]/
        metadata[:subject_method_name] = d.gsub /^[.#]/, ""
      end
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

end
