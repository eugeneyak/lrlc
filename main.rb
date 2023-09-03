require_relative 'lrlc'

token      = ENV["TOKEN"]
entrypoint = ENV["ENTRYPOINT"]

bot = Telegram::Bot.new(token, entrypoint: entrypoint)

bot.start! do |message|
  ::Processor.new(message, bot).call
end

# bot.message 250617930, "F"

# bot.message 250617930, "F",
#   reply_markup: {
#     remove_keyboard: true,
#   }

# bot.media_group(250617930, [
#   {
#     type: "photo",
#     media: "AgACAgIAAxkBAAOsZOkrfpjWUWYlpwABb8IyVMqQJO3RAAKEyjEbs7tIS6t3ZX2Gu_kMAQADAgADcwADMAQ",
#   },
#   {
#     type: "photo",
#     media: "AgACAgIAAxkBAAOtZOkrfpnhc9ssxrs4xExCEDy1ioIAAoXKMRuzu0hLQO-O-zaP5bQBAAMCAANzAAMwBA"
#   }
# ], caption: "FUCK EACH")


# bot.text(-984149820, "а")

# bot.dice(-984149820)


#
# state = States::Receipt.first
#
# p state.vin


# Update = Data.define(:id, :text)
