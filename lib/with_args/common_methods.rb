module RspecWithArgs
  module CommonClassMethods
    def descriptee(m)
      m[:example_group][:description_args].first
    end
  end

  module RspecWithArgs::CommonInstanceMethods
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
end
