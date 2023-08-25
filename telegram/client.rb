# frozen_string_literal: true

require 'excon'
require 'json'

class Telegram::Client
  def initialize
    @token = ENV.fetch("TOKEN")
    @connection = Excon.new(
      "https://api.telegram.org",
      persistent: true,
      headers: { "Content-Type" => "application/json" },
    )
  end

  attr_reader :connection, :token

  def get(path, **params)
    answer = connection
      .get(path: "bot#{token}/#{path}", query: params)

    handle answer
  end

  def post(path, **body)
    LRLC.logger.debug "REQUEST TO TELEGRAM"
    LRLC.logger.debug body.inspect

    answer = connection
      .post(path: "bot#{token}/#{path}", body: JSON.generate(body))

    handle answer
  end

  private

  def handle(answer)
    data = JSON.parse(answer.body, symbolize_names: true)

    if data[:ok]
      data[:result]
    else
      raise RuntimeError, data[:description]
    end
  end
end
