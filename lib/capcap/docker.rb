# frozen_string_literal: true

%w[tasks docker].each do |plugin|
  Dir[File.join(File.expand_path(__dir__), "..", "capistrano", plugin, "**", "*.rake")].each do |file|
    load file
  end
end

before :"deploy:check:linked_files", :"deploy:create:linked_files"
after :"deploy:symlink:release", :"deploy:docker:build"
before :"deploy:docker:build", :"deploy:set_permissions:chmod"
before :"deploy:docker:build", :"deploy:docker:network:create"
after :"deploy:docker:build", :"deploy:docker:update"
after :"deploy:docker:update", :"deploy:docker:cleanup"
