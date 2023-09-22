# frozen_string_literal: true

require_relative 'config'
require_relative 'client'

require_relative 'info'

class Telegram::Bot
  def initialize(token, **conf)
    @client = Telegram::Client.new(token)
    @config = Telegram::Config.new(**conf)

    yield config if block_given?
  end

  attr_reader :client, :config

  def start!(&yielder)
    receiver =
      if config.entrypoint.present?
        Telegram::Receiver::Webhook.new(client, config.entrypoint)
      else
        Telegram::Receiver::Polling.new(client)
      end

    me.then do |info|
      config.logger.info "#{info.name}"
      config.logger.info "ID: #{info.id}"
      config.logger.info "Username: #{info.username}"
      config.logger.info "Can join groups: #{info.can_join_groups}"
      config.logger.info "Can read all group messages: #{info.can_read_all_group_messages}"
      config.logger.info "Supports inline queries: #{info.supports_inline_queries}"
    end

    config.logger.info "Use #{receiver.class} strategy"

    receiver.call(&yielder)
  end

  def me
    client
      .then { _1.get("getMe") }
      .then { Telegram::Info.new(**_1) }
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
