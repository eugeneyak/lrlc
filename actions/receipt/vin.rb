# # frozen_string_literal: true
#
# module Action::Receipt
#   class VIN < Action::Base
#     # register ::States::Receipt, step: :vin
#
#     message do |message, from|
#       if message.text.size == 8
#         state.step = "photos"
#         state.payload = { "vin" => message.text }
#
#         bot.text(from, "СПС")
#         bot.text(from, "Теперь грузи фоточки")
#
#       else
#         bot.text(from, "Введи нормально, 8 символов")
#       end
#     end
#   end
# end
