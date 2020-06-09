ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../survey.rb'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_view_survey

  end

  def test_submit_survey

  end

  def test_redirect_to_results

  end

  def test_redirect_to_survey

  end  
end