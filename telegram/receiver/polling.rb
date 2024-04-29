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
        updates = client.get "getUpdates", offset: offset, timeout: 100

        updates.each do |update|
          update[:message].tap do |data|
            yield Telegram::Message.new(**data) if data.present?
          end

          update[:callback_query].tap do |data|
            yield Telegram::CallbackQuery.new(**data) if data.present?
          end

          read update[:update_id]
        end

      GC.start

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
