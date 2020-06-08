require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'tilt/erubis'

INSTRUMENT = [
  {
    question: 'A bat and a ball cost $1.10 in total. The bat costs $1.00 more than the ball. How much does the ball cost?',
    solution: '5',
    unit: 'cents'
  },
  {
    question: 'If it takes 5 machines 5 minutes to make 5 widgets, how long would it take 100 machines to make 100 widgets?',
    solution: '5',
    unit: 'minutes'
  },
  {
    question: 'In a lake, there is a patch of lily pads. Every day, the patch doubles in size. If it takes 48 days for the patch to cover the entire lake, how long would it take for the patch to cover half of the lake?',
    solution: '47',
    unit: 'days'
  }
]

configure do
  enable :sessions
  set :session_secret, 'iamsogreat'
end

helpers do

end

def score_test
  score = 0
  INSTRUMENT.each_with_index do |item, idx|
    score += 1 if (item[:solution] == session[:answers][idx])
  end
  score
end

get '/' do
  redirect '/results' if session[:score]
  erb :survey, layout: :layout
end

post '/survey' do  
  session[:answers] = [params[:quest0], params[:quest1], params[:quest2]]
  session[:score] = score_test
  redirect '/results'
end

get '/results' do
  redirect '/' unless session[:answers]
  @answer = session[:answers]
  erb :results, layout: :layout
end

post '/reset' do
  session.delete(:answer)
  session.delete(:score)
  redirect '/'
end
