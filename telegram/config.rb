# frozen_string_literal: true

class Telegram::Config
  def initialize(logger: Logger.new(STDOUT), entrypoint: nil)
    self.logger = logger
    self.entrypoint = entrypoint
  end
  
  attr_accessor :entrypoint
  attr_reader :logger

  def logger=(logger)
    @logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
