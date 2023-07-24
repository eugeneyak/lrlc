# frozen_string_literal: true

module Telegram::Data
  Bot = Data.define(
    :id,
    :bot,
    :name,
    :username,
    :can_join_groups,
    :can_read_all_group_messages
  )

  User = Data.define(:id, :is_bot, :first_name, :last_name, :username, :language_code)

  Message = Data.define(:id, :text)

  Photo = Data.define(:id, :file_id, :caption)
end
