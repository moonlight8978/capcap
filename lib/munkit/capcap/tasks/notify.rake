# frozen_string_literal: true

require "munkit/telegram"

namespace :deploy do
  namespace :notify do
    task :telegram do
      next if dry_run?

      Munkit::Telegram.notify(
        group_id: fetch(:telegram_group),
        topic_id: fetch(:telegram_topic),
        token: fetch(:telegram_token),
        message: fetch(:telegram_message),
        columns: fetch(:telegram_columns)
      )
    end
  end
end

namespace :load do
  task :defaults do
    set :telegram_token, -> { ENV["TELEGRAM_TOKEN"] }
    set :telegram_message, ""
    set :telegram_columns, ""
    set :telegram_topic, nil
  end
end
