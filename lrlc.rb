# frozen_string_literal: true

require_relative 'config/database'
require_relative 'telegram'

require_relative 'state'
require_relative 'processor'
require_relative 'helpers/vis'

Dir[File.join __dir__, "commands", "**", "*.rb"].each do
  require _1
end

module LRLC
  module_function def logger
    require 'active_support/isolated_execution_state'
    require 'active_support/tagged_logging'

    @logger ||= begin
      STDOUT.sync = true

      logger = Logger.new(STDOUT)
      logger.formatter = Logger::Formatter.new

      ActiveSupport::TaggedLogging.new(logger)
    end
  end
end
