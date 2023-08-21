# frozen_string_literal: true

require_relative 'client'

class Telegram::Bot
  def initialize
    @client = Telegram::Client.new
  end

  attr_reader :client

  def me
    data = client.get("getMe")

    Telegram::Data::Bot.new(
      id: data["id"],
      bot: data["is_bot"],
      name: data["first_name"],
      username: data["username"],
      can_join_groups: data["can_join_groups"],
      can_read_all_group_messages: data["can_read_all_group_messages"],
    )
  end

  def message(user, text, **payload)
    client.post "sendMessage",
      chat_id: destination(user),
      text: text,
      **payload
  end

  def media_group(user, media)
    client.post "sendMediaGroup",
      chat_id: destination(user),
      media: media
  end

  def delete(user, message)
    client.post "deleteMessage",
      chat_id: destination(user),
      message_id: message
  end

  def dice(user)
    client.post "sendDice",
      chat_id: destination(user),
      emoji: "🪙"
  end

  private

  def destination(user)
    case user
    when Telegram::User
      user.id
    when Integer
      user
    end
  end
end
