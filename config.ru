require "bundler/setup"

puts 'Preparing project...'

puts 'Preparing database...'
require_relative 'config/database'

puts 'Preparing server...'
require_relative 'config/hanami'

run App.new
