# frozen_string_literal: true

# @nodoc
module Munkit
  # @nodoc
  module Capcap
    # @nodoc
    module Helper
      @@plugins = Set.new

      def self.load_plugin(*plugins)
        plugins.each do |plugin|
          if @@plugins.add?(plugin)
            Dir[File.join(File.expand_path(__dir__), "tasks", "#{plugin}.rake")].each do |file|
              load file
            end
          else
            puts "Plugin #{plugin} is already loaded"
          end
        end
      end
    end
  end
end
