Bundler.require :default
require 'yaml'
require 'pry' unless ENV['RACK_ENV'] == 'production'


module Shorty
  module_function

  def redis
    config = YAML::load_file(File.join('./config', 'redis.yml'))
    @redis ||= Redis.new(config['redis'])
  end
end

require './lib/hash.rb'
require './lib/date_time.rb'
require './lib/shorty/errors.rb'
require './lib/shorty/controllers/base.rb'
require './lib/shorty/controllers/create.rb'
require './lib/shorty/controllers/show.rb'
require './lib/shorty/controllers/stats.rb'
require './lib/shorty/application.rb'
require './lib/shorty/shortcode/validator.rb'
require './lib/shorty/shortcode/generator.rb'
require './lib/shorty/models/shorty.rb'
