path = File.expand_path('../with_args', __FILE__)
module RspecWithArgs; end

require "#{path}/common_methods"
Dir["#{path}/*"].each do |file|
  require file
end
