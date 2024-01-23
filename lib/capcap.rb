# frozen_string_literal: true

require_relative "capcap/version"

require 'capistrano/file-permissions'

require 'capistrano/scm/git-with-submodules'
install_plugin Capistrano::SCM::Git::WithSubmodules

module Capcap
  class Error < StandardError; end
  # Your code goes here...
end
