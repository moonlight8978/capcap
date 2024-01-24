# frozen_string_literal: true

# @nodoc
module Telegram
  LINE_BREAK = "&#10;"

  module_function

  # @param [String] text
  def parse_columns(text)
    columns = text.split("|W|").map(&:strip).drop(1)

    columns.each.with_index.each_with_object([]) do |column_with_index, acc|
      column, index = column_with_index
      acc.push({ content: "", title: "", variant: "" }) if (index % 3).zero?

      current_column = acc.last

      case index % 3
      when 0
        current_column[:variant] = column
      when 1
        current_column[:title] = column
      when 2
        current_column[:content] = column
      end
    end
  end

  def html_escape(text)
    escaped = text.gsub(%r{<html-escape>((.|\n|\r\n)*?)</html-escape>}) do |_match|
      ERB::Util.html_escape_once(::Regexp.last_match(1)).gsub(/[\r\n]/, LINE_BREAK)
    end

    escaped.strip.chomp(LINE_BREAK).delete_prefix(LINE_BREAK).strip
  end

  def to_telegram_message(columns)
    columns.map do |column|
      content = ERB::Util.html_escape_once(column[:content])

      if column[:variant] == "full"
        "▪️ <b>#{column.title}</b>#{lineBreak}#{content}"
      else
        "▪️ <b>#{column.title}</b>: #{content}"
      end
    end
  end
end

namespace :deploy do
  namespace :notify do
    task :telegram do
      require "httparty"

      group_id = fetch(:telegram_group_id)
      topic_id = fetch(:telegram_topic_id)
      token = fetch(:telegram_token, ENV["TELEGRAM_TOKEN"])
      message = fetch(:telegram_message, "")
      columns = to_telegram_message(Telegram.html_escape(fetch(:telegram_columns, "")))

      HTTParty.post(
        "https://api.telegram.org/bot#{token}/sendMessage",
        body: {
          chat_id: group_id,
          text: [message, Telegram.LINE_BREAK, columns].join,
          parse_mode: "HTML",
          disable_web_page_preview: true,
          reply_to_message_id: topic_id
        }
      )
    end
  end
end
