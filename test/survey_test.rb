ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../survey.rb'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def all_correct
    { 'rack.session' =>
      { answers: ['5', '5', '47'],
        score: 3
      }
    }
  end

  def session
    last_request.env['rack.session']
  end

  def test_view_survey
    get '/'
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input type='submit' value='Score Test'>"
  end

  def test_redirect_to_survey
    get '/results'
    assert_equal 302, last_response.status

    get last_response['Location']
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input type='submit' value='Score Test'>"
  end  

  def test_submit_survey_none_correct
    post '/survey' 
    assert_equal 302, last_response.status

    get last_response['Location']
    assert_equal 200, last_response.status
    assert_includes last_response.body, 'You scored 0 out of 3!'
    assert_includes last_response.body, "<input type='submit' value='Try Again'>"
  end

  def test_submit_survey_some_correct
    post '/survey', { quest0: '5' }
    assert_equal 302, last_response.status

    get last_response['Location']
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<div class='correct'>Correct!</div>"
    assert_equal 1, session[:score]
    assert_includes last_response.body, "<input type='submit' value='Try Again'>"
  end

  def test_redirect_to_results
    get '/', {}, all_correct
    assert_equal 302, last_response.status

    get last_response['Location']
    assert_equal 200, last_response.status
    assert_includes last_response.body, 'You scored 3 out of 3!'
    assert_includes last_response.body, "<input type='submit' value='Try Again'>"
  end

  def test_reset
    get '/results', {}, all_correct
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input type='submit' value='Try Again'>"

    post '/reset'
    assert_equal 302, last_response.status
    assert_nil session[:answers]
    assert_nil session[:score]

    get last_response['Location']
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input type='submit' value='Score Test'>"
  end
end