require_relative '../telegram'

hook = Telegram::Webhook.new

on_booted do
  hook.set
end

at_exit do
  hook.clear
end
