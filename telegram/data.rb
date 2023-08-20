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

  # User = Data.define(:id)
  #
  # Message = Data.define(:id, :text)
  # Command = Data.define(:id, :command)
  #
  # Photo = Data.define(:id, :file_id, :caption)

  User = Data.define(:id)

  Chat = Data.define(:id, :type) do
    def private?
      type == "private"
    end

    def group?
      type == "group"
    end
  end

  Message = Data.define(:id, :from, :chat, :text) do
  #   User = Data.define(:id)
  #
  #   Chat = Data.define(:id, :type) do
  #     def private?
  #       type == "private"
  #     end
  #
  #     def group?
  #       type == "group"
  #     end
  #   end
  #
  #   def initialize(id:, from:, chat: )
  #     super(amount: Float(amount), unit:)
  #   end
  end
end
