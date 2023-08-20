# frozen_string_literal: true

module Telegram::Receiver
  class Webhook
    def initialize
      @client = Telegram::Client.new
    end

    attr_reader :client

    def set
      client.post "setWebhook",
        url: url,
        drop_pending_updates: true

      puts "Webhook #{url} was set"
    end

    def delete(silent: false)
      client.post "deleteWebhook",
        drop_pending_updates: true

      puts "Webhook was deleted" unless silent
    end

    def url
      ENV["ENTRYPOINT"] || raise(RuntimeError, "Set the ENTRYPOINT env")
    end
  end
end
