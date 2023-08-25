# frozen_string_literal: true

require_relative 'client'

class Telegram::Bot
  def initialize
    @client = Telegram::Client.new
  end

  attr_reader :client

  def start!
    entrypoint = ENV["ENTRYPOINT"]

    if entrypoint
      LRLC.logger.info "Webhook mode booting"
      Telegram::Receiver::Webhook.new(entrypoint).call
    else
      LRLC.logger.info "Polling mode booting"
      Telegram::Receiver::Polling.new.call
    end
  end

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
      chat_id: addressee(user),
      text: text,
      **payload
  end

  def media_group(user, media, caption: nil)
    if caption
      media.first[:caption] = caption
    end

    client.post "sendMediaGroup",
      chat_id: addressee(user),
      media: media
  end

  def delete(user, message)
    client.post "deleteMessage",
      chat_id: addressee(user),
      message_id: message
  end

  def dice(user)
    client.post "sendDice",
      chat_id: addressee(user),
      emoji: "🪙"
  end

  private

  def addressee(user)
    case user
    when Telegram::User
      user.id
    when Integer
      user
    end
  end
end
