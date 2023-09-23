require_relative 'receivers/polling'
require_relative 'receivers/webhook'

class Telegram::Receiver
  def initialize(client, config)
    @client = client
    @config = config
  end

  attr_reader :client, :config

  def call
    receiver = strategy

    config.logger.info "Use #{receiver.class} strategy"

    receiver.call do |message|
      config.logger.tagged(message.id, message.from.identifier) do
        config.logger.info message.to_h
        yield message
      end
    end
  end

  private

  def strategy
    if config.entrypoint.present?
      Telegram::Receivers::Webhook.new(client, config.entrypoint)
    else
      Telegram::Receivers::Polling.new(client)
    end
  end
end
