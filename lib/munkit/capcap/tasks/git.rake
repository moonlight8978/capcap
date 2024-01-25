# frozen_string_literal: true

namespace :load do
  task :defaults do
    set :git_sha, -> { `git rev-parse HEAD`.chomp }

    set :git_sha_short, -> { `git rev-parse --short HEAD`.chomp }

    set :git_author, -> { `git log -1 --pretty=format:'%an'`.chomp }

    set :git_commit_format, -> { "- %s (%h by %aN)" }

    set :git_changelog, lambda {
      parents = `git show -s --pretty=%ph --quiet HEAD`.chomp.split(" ")

      next `git log -1 --pretty=format:"#{fetch(:git_commit_format)}"` if parents.size == 1

      prev = parents.first
      `git log --oneline --no-merges --pretty=format:"#{fetch(:git_commit_format)}" #{prev}..HEAD`.chomp
    }
  end
end
