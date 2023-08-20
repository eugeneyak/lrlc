class Telegram::User
  def initialize(id:, username: nil, **)
    @id = id
    @username = username
  end

  attr_reader :id, :username
end

class Telegram::Chat
  def initialize(id:, type:, **)
    @id = id
    @type = type
  end

  attr_reader :id, :type
end

class Telegram::Message
  def initialize(message_id:, from:, chat:, date:, **payload)
    @id = message_id
    @from = Telegram::User.new(**from)
    @chat = Telegram::Chat.new(**chat)
    @date = date
    @payload = payload
  end

  attr_reader :id, :from, :chat, :payload

  def text?
    !!payload[:text]
  end

  def command?
    command = if entities
      entities.find { |e| e[:type] == "bot_command" }
    end

    !!command
  end

  def command
    command = if entities
      entities.find { |e| e[:type] == "bot_command" }
    end

    offset = command[:offset] + 1
    length = command[:length]

    payload[:text][offset..length].to_sym
  end

  def photo?
    !!payload[:photo]
  end

  def entities
    payload[:entities]
  end
end
