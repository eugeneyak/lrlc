# frozen_string_literal: true

class Processor
  def initialize(message)
    @message = message
  end

  attr_reader :message

  def call
    LRLC.logger.info

    LRLC.logger.tagged(message.id, message.from.identifier) do
      LRLC.logger.info message.inspect

      if message.command?
        handle_command
      else
        handle_message
      end
    end
  end

  def handle_command
    LRLC.logger.info "Invoke #{message.command.inspect} command"

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

    when :extradition
      state = Command::Extradition::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Extradition::Handler.new(message, state).welcome

    when :replacement
      state = Command::Replacement::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Replacement::Handler.new(message, state).welcome

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

    LRLC.logger.info state.inspect if state

    case state
    when Command::Receipt::State
      Command::Receipt::Handler.new(message, state).call

    when Command::Extradition::State
      Command::Extradition::Handler.new(message, state).call

    when Command::Replacement::State
      Command::Replacement::Handler.new(message, state).call

    when Command::Note::State
      Command::Note::Handler.new(message, state).call

    else
      LRLC.logger.info "NICHEGO NE DETCTED"
    end
  end

end
