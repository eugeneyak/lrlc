# frozen_string_literal: true

class Telegram::Update
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def call
    case data
    in { message: { message_id: id, from: from, entities: [*, { type: "bot_command" }, *] } }
      puts "THIS IS COMMAND"

      p Telegram::Data::User.new(**from)
      p Telegram::Data::Message.new(id: id, text: nil)

    in { message: { message_id: id, from: from, caption: caption, photo: [{ file_id: file_id }, *] } }
      puts "THIS IS IMAGE"

      p Telegram::Data::User.new(**from)
      p Telegram::Data::Photo.new(id: id, caption: caption, file_id: file_id )

    in { message: { message_id: id, from: from, photo: [{ file_id: file_id }, *] } }
      puts "THIS IS IMAGE"

      p Telegram::Data::User.new(**from)
      p Telegram::Data::Photo.new(id: id, caption: nil, file_id: file_id )

    in { message: { message_id: id, from: from, text: text } }
      puts "THIS IS BORING MESSAGE"

      p Telegram::Data::User.new(**from)
      p Telegram::Data::Message.new(id: id, text: text)

    else
      puts "Unprocessable message"
    end
  end
end
