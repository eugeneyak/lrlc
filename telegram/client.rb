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
      # debug: true
    )
  end

  attr_reader :connection, :token

  def get(path)
    answer = connection
      .get(path: "bot#{token}/#{path}")

    data = JSON.parse(answer.body)

    if data["ok"]
      data["result"]
    else
      raise RuntimeError, data["description"]
    end
  end

  def post(path, **body)
    answer = connection
      .post(path: "bot#{token}/#{path}", body: JSON.generate(body))

    data = JSON.parse(answer.body)

    if data["ok"]
      data["result"]
    else
      raise RuntimeError, data["description"]
    end
  end
end
