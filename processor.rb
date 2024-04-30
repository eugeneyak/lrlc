# frozen_string_literal: true

class Processor
  def initialize(message, bot)
    @message = message
    @bot = bot
  end

  attr_reader :message, :bot

  def call
    LRLC.logger.tagged(message.id, message.from.identifier) do
      if message.command?
        handle_command
      else
        handle_message
      end
    end
  end

  def handle_command
    LRLC.logger.info "Try to invoke #{message.command.inspect} command"

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

      Command::Receipt::Handler.new(message, state, bot).welcome

    when :maintenance
      state = Command::Maintenance::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Maintenance::Handler.new(message, state, bot).welcome

    when :extradition
      state = Command::Extradition::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Extradition::Handler.new(message, state, bot).welcome

    when :replacement
      state = Command::Replacement::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Replacement::Handler.new(message, state, bot).welcome

    when :notes
      state = Command::Note::State.create(
        user: message.from.id,
        chat: message.chat.id
      )

      Command::Note::Handler.new(message, state, bot).welcome
    else
      LRLC.logger.info "Command #{message.command.inspect} not found"
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
      Command::Receipt::Handler.new(message, state, bot).call

    when Command::Maintenance::State
      Command::Maintenance::Handler.new(message, state, bot).call

    when Command::Extradition::State
      Command::Extradition::Handler.new(message, state, bot).call

    when Command::Replacement::State
      Command::Replacement::Handler.new(message, state, bot).call

    when Command::Note::State
      Command::Note::Handler.new(message, state, bot).call

    else
      LRLC.logger.info "NICHEGO NE DETCTED"
    end

    begin
      LRLC.logger.info state.reload.inspect if state
    rescue Sequel::NoExistingObject
      :noop
    end
  end

end
