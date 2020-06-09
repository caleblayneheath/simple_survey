require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'tilt/erubis'

INSTRUMENT = [
  {
    question: 'A bat and a ball cost $1.10 in total. The bat costs $1.00 more than the ball. How much does the ball cost?',
    solution: '5',
    unit: 'cents',
    explanation: 'You might be tempted to say the ball is $0.10. Although $1.00 + $0.10 does equal $1.10, if you take $1.00 – $0.10 you get $0.90, but the problem requires that the bat costs $1 more than the ball. So, the ball must cost $0.05, and the bat must cost $1.05 since $1.05 + $0.05 = $1.10'
  },
  {
    question: 'If it takes 5 machines 5 minutes to make 5 widgets, how long would it take 100 machines to make 100 widgets?',
    solution: '5',
    unit: 'minutes',
    explanation: 'The rate of 5 machines is 1 widget per minute, so the rate of 100 machines is 1 x 20 = 20 widgets per minute, so it will take 100 machines 100/20 = 5 minutes to make 100 widgets.'

  },
  {
    question: 'In a lake, there is a patch of lily pads. Every day, the patch doubles in size. If it takes 48 days for the patch to cover the entire lake, how long would it take for the patch to cover half of the lake?',
    solution: '47',
    unit: 'days',
    explanation: 'If the lake is fully covered on day 48, then it must have been only half covered the previous day. So the lake is half covered after 47 days.'
  }
]

configure do
  enable :sessions
  set :session_secret, 'iamsogreat'
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
