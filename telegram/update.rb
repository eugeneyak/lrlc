# frozen_string_literal: true

require_relative '../state'
require_relative '../action'
require_relative '../processor'

class Telegram::Update
  def initialize(data)
    @from    = Telegram::Data::User.new(id: data[:message][:from][:id].to_i)
    @message = parse(data)
  end

  attr_reader :message, :from

  def call
    Processor.new(message, from).call
  end

  def parse(data)
    case data
    in { message: { message_id: id, text: command, entities: [*, { type: "bot_command" }, *] } }
      puts "THIS IS COMMAND"

      # p Telegram::Data::User.new(**from)
      Telegram::Data::Command.new(id: id, command: command[1..].to_sym)

    # in { message: { message_id: id, caption: caption, photo: [{ file_id: file_id }, *] } }
    #   puts "THIS IS IMAGE"
    #
    #   # p Telegram::Data::User.new(**from)
    #   Telegram::Data::Photo.new(id: id, caption: caption, file_id: file_id )

    in { message: { message_id: id, photo: [{ file_id: file_id }, *] } }
      puts "THIS IS IMAGE"

      # p Telegram::Data::User.new(**from)
      Telegram::Data::Photo.new(id: id, caption: nil, file_id: file_id )

    in { message: { message_id: id, text: text } }
      puts "THIS IS BORING MESSAGE"

      # p Telegram::Data::User.new(**from)
      Telegram::Data::Message.new(id: id, text: text)

    else
      puts "Unprocessable message"
    end
  end
end
