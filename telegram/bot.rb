# frozen_string_literal: true

require_relative 'webhook'
require_relative 'client'

class Telegram::Bot
  def initialize
    @client = ENV.fetch("TOKEN").then { Telegram::Client.new(_1) }
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
end
