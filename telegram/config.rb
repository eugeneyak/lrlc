# frozen_string_literal: true

class Telegram::Config
  def initialize(logger: Logger.new, entrypoint: nil)
    self.logger = logger
    self.entrypoint = entrypoint
  end
  
  attr_accessor :logger, :entrypoint
end