load File.expand_path('../../capistrano/tasks/shared.rake', __FILE__)
load File.expand_path('../../capistrano/tasks/docker.rake', __FILE__)

before :"deploy:check:linked_files", :"deploy:create:linked_files"
after :"deploy:symlink:release", :"deploy:docker:build"
before :"deploy:docker:build", :"deploy:set_permissions:chmod"
before :"deploy:docker:build", :"deploy:docker:network:create"
after :"deploy:docker:build", :"deploy:docker:update"
after :"deploy:docker:update", :"deploy:docker:cleanup"
