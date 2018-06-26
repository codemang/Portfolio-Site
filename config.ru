require 'rubygems'
require 'bundler'
require 'json'

Bundler.require

require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

require './app'
run App
