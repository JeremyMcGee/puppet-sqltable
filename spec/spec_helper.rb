dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'test/unit'
require 'mocha/setup'
require 'puppet'
require 'rspec'
