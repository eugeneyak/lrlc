require "hanami/api"
require "hanami/middleware/body_parser"

require_relative '../telegram'

puts "#{Telegram::Bot.new.me.username} starting..."

class App < Hanami::API
  use Hanami::Middleware::BodyParser, :json

  post "/" do
    p params
    Telegram::Update.new(params).call
    halt(200)
  end
end
