# frozen_string_literal: true

module Telegram::Receiver
  class Polling
    def initialize(client)
      @client = client
      @offset = nil
    end

    attr_reader :client, :offset

    def call
      loop do
        updates = client.get "getUpdates", offset: offset

        updates.each do |update|
          data = update.fetch(:message)

          yield Telegram::Message.new(**data)

          read update[:update_id]
        end

      rescue Excon::Error::Socket
        next

      rescue Interrupt
        exit true
      end
    end

    def read(last)
      @offset = last + 1
    end
  end
end
