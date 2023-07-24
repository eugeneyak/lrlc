# frozen_string_literal: true

class Telegram::Webhook
  def initialize
    @client = ENV.fetch("TOKEN").then { Telegram::Client.new(_1) }
  end

  attr_reader :client

  def url
    ENV["ENTRYPOINT"] || raise(RuntimeError, "Set the ENTRYPOINT env")
  end

  def set
    client.post("setWebhook", url: url)
    puts "Webhook #{url} was set"
  end

  def clear
    client.post("deleteWebhook", drop_pending_updates: true)
    puts "Webhook #{url} was deleted"
  end
end
