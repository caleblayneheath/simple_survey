require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'tilt/erubis'

SOLUTION = ['5', '5', '47']

configure do
  enable :sessions
  set :session_secret, 'iamsogreat'
end

helpers do
  def format_result(solution, answer)
    
  end
end

def score_test
  score = 0
  SOLUTION.each_with_index do |item, idx|
    score += 1 if (item == session[:answer][idx])
  end
  score
end

get '/' do
  redirect '/results' if session[:score]
  erb :survey, layout: :layout
end

post '/survey' do  
  session[:answer] = [params[:quest1], params[:quest2], params[:quest3]]
  session[:score] = score_test
  redirect '/results'
end

get '/results' do
  @answer = session[:answer]
  erb :results, layout: :layout
end