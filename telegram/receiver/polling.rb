# frozen_string_literal: true

module Telegram::Receiver
  class Polling
    def initialize
      @client = Telegram::Client.new
      @offset = nil
    end

    attr_reader :client, :offset

    def call
      loop do
        updates = client.post "getUpdates", offset: offset

        updates.each do |update|
          data = update.fetch(:message)

          message = Telegram::Message.new(**data)

          ::Processor.new(message).call

          self.offset = update[:update_id]
        end

      rescue OpenSSL::SSL::SSLError
        next

      rescue Interrupt
        exit true
      end
    end

    def offset=(last)
      @offset = last + 1
    end
  end
end
