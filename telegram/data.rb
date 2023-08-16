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

  User = Data.define(:id)

  Message = Data.define(:id, :text)
  Command = Data.define(:id, :command)

  Photo = Data.define(:id, :file_id, :caption)
end
