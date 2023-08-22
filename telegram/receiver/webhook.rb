# frozen_string_literal: true

require 'webrick'

module Telegram::Receiver
  class Webhook
    def initialize(entrypoint)
      @entrypoint = entrypoint

      @client = Telegram::Client.new
      @server = WEBrick::HTTPServer.new
    end

    attr_reader :entrypoint, :client, :server

    def call
      set_hook

      server.mount_proc '/' do |req, _res|
        update = JSON
          .parse(req.body, symbolize_names: true)
          .fetch(:message)

        message = Telegram::Message.new(**update)

        ::Processor.new(message).call
      end

      trap('INT') do
        server.shutdown
        delete_hook
      end

      server.start
    end

    private

    def set_hook
      client.post "setWebhook",
        url: entrypoint,
        drop_pending_updates: true

      puts "Webhook #{entrypoint} was set"
    end

    def delete_hook(silent: false)
      client.post "deleteWebhook",
        drop_pending_updates: true

      puts "Webhook #{entrypoint} was deleted" unless silent
    end
  end
end
