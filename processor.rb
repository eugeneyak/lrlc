# frozen_string_literal: true

class Processor
  def initialize(message)
    @message = message
  end

  attr_reader :message

  def call
    if message.command?
      p message.command

      case message.command
      when :start
        p "START"

      when :receipt
        p "RECEIPT"

        State::Receipt.create(
          user: message.from.id,
          chat: message.chat.id
        )
      end

    else

    end

  end

end
