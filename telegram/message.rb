class Telegram::User
  def initialize(id:, username: nil, first_name: nil, last_name: nil, **)
    @id         = id
    @username   = username
    @first_name = first_name
    @last_name  = last_name
  end

  attr_reader :id, :username, :first_name, :last_name

  def name
    "#{first_name} #{last_name}".strip
  end

  def identifier
    "#{id}:#{name}"
  end

  def link
    "tg://user?id=#{id}"
  end
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

  def to_h
    payload
  end

  def text?
    !!text
  end

  def text
    payload[:text]
  end

  def command?
    !!command
  end

  def command
    return unless entities

    command = entities
      .find { |e| e[:type] == "bot_command" }

    return unless command

    offset = command[:offset] + 1
    length = command[:length]

    payload[:text][offset..length].to_sym
  end

  def photo?
    !!payload[:photo]
  end

  def photo
    return unless payload[:photo]
    return unless payload[:photo].first
    return unless payload[:photo].first[:file_id]

    payload[:photo].first[:file_id]
  end

  def entities
    payload[:entities]
  end
end
