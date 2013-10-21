require_relative 'common_methods'
module RspecWithArgs
  module ClassExampleGroup
    extend RspecWithArgs::CommonClassMethods
    include RspecWithArgs::CommonInstanceMethods
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
end
