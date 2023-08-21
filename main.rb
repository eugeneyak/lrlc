require_relative 'config/database'
require_relative 'telegram'

bot = Telegram::Bot.new

Telegram::Receiver::Polling.new.call




# bot.message 250617930, "F",
#   reply_markup: {
#     remove_keyboard: true,
#   }

# bot.media_group(250617930, [
#   {
#     type: "photo",
#     media: "AgACAgIAAxkBAAIBuWTXX28TZV1eGCDyD7L6qMTqEjm9AAKG0DEbxm64SqbaRHQyrNm5AQADAgADcwADMAQ"
#   },
#   {
#     type: "photo",
#     media: "AgACAgIAAxkBAAIBumTXX28pdPzfc-n0sxtp0hquR3wvAAIj0DEbxm7ASrBINgXGlz1mAQADAgADcwADMAQ"
#   }
# ])


# bot.text(-984149820, "а")

# bot.dice(-984149820)


#
# state = States::Receipt.first
#
# p state.vin


# Update = Data.define(:id, :text)
