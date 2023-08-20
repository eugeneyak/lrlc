# frozen_string_literal: true

module Telegram
end

require_relative 'telegram/bot'
require_relative 'telegram/message'
require_relative 'telegram/receiver/polling'
require_relative 'telegram/receiver/webhook'
require_relative 'state'
require_relative 'processor'

Dir[File.join __dir__, "commands", "**", "*.rb"].each do
  require _1
end
