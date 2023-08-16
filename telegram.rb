# frozen_string_literal: true

module Telegram
end

require_relative 'telegram/bot'
require_relative 'telegram/webhook'
require_relative 'telegram/data'
require_relative 'telegram/update'
require_relative 'registry'
require_relative 'state'

Dir[File.join __dir__, "states", "*.rb"].each do
  require _1
end

require_relative 'action'

Dir[File.join __dir__, "actions", "**", "*.rb"].each do
  require _1
end
