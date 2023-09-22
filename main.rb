require_relative 'lrlc'

token      = ENV["TOKEN"]
entrypoint = ENV["ENTRYPOINT"]

bot = Telegram::Bot.new token do |conf|
  conf.entrypoint = entrypoint,
  conf.logger = LRLC.logger
end

bot.start! do |message|
  ::Processor.new(message, bot).call
end
