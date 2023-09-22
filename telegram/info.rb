# frozen_string_literal: true

module Telegram
  Info = Data.define(
    :id, :is_bot, :first_name, :username,
    :can_join_groups, :can_read_all_group_messages, :supports_inline_queries
  ) do
    alias bot? is_bot
    alias name first_name
  end
end
