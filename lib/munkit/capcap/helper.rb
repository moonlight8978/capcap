# frozen_string_literal: true

# @nodoc
module Munkit
  # @nodoc
  module Capcap
    # @nodoc
    module Helper
      def self.load_plugin(*plugins)
        plugins.each do |plugin|
          Dir[File.join(File.expand_path(__dir__), "tasks", "#{plugin}.rake")].each do |file|
            load file
          end
        end
      end
    end
  end
end
