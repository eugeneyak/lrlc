# frozen_string_literal: true

require 'excon'
require 'json'

class Telegram::Client
  def initialize(token)
    @token = token
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
      .then { |response| JSON.parse(response.body, symbolize_names: true) }

    handle answer
  end

  def post(path, **body)
    LRLC.logger.info "TG API Request : #{path.inspect} : #{body.inspect}"

    answer = connection
      .post(path: "bot#{token}/#{path}", body: JSON.generate(body))
      .then { |response| JSON.parse(response.body, symbolize_names: true) }

    LRLC.logger.info "TG API Response : #{answer}"

    handle answer
  end

  private

  def handle(answer)
    if answer[:ok]
      answer[:result]
    else
      raise RuntimeError, answer[:description]
    end
  end
end
