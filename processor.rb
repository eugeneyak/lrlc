# frozen_string_literal: true

class Processor
  def initialize(message)
    @message = message
  end

  attr_reader :message

  def call
    p message

    if message.command?
      handle_command
    else
      handle_message
    end
  end

  def handle_command
    DB.from(:states)
      .where(user: message.from.id, chat: message.chat.id)
      .delete

    case message.command
    when :start
      p "START"

    when :receipt
      state = Command::Receipt::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Receipt::Handler.new(message, state).welcome

    when :notes
      state = Command::Note::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Note::Handler.new(message, state).welcome
    end

  end

  def handle_message
    state = State::Base.find(
      user: message.from.id,
      chat: message.chat.id
    )

    case state
    when Command::Receipt::State
      p "Command::Receipt::State DETECTED"
      Command::Receipt::Handler.new(message, state).call

    when Command::Note::State
      p "Command::Receipt::State DETECTED"
      Command::Note::Handler.new(message, state).call

    else
      p "NICHEGO NE DETCTED"
    end
  end

end
