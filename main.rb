require_relative 'lrlc'

token      = ENV["TOKEN"]
entrypoint = ENV["ENTRYPOINT"]

bot = Telegram::Bot.new(token, entrypoint: entrypoint)

bot.start! do |message|
  ::Processor.new(message, bot).call
end
