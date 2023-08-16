# # frozen_string_literal: true
#
# module Action::Receipt
#   class Photos < Action::Base
#     # register ::States::Receipt, step: :photos
#
#     photo do |message, from|
#       photos = state.payload["photos"] || []
#       photos << message.file_id
#
#       state.payload = state.payload.merge("photos" => photos.uniq)
#
#       p message
#
#
#     end
#   end
# end
