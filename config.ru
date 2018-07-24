require 'rubygems'
require 'bundler'
require 'json'

Bundler.require(:default, :development)

require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

require './app'
run App
