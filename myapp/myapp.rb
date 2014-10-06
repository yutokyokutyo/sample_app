require 'sinatra'

get '/hello/:name' do
  "hello #{params[:name]}"
end

get '/' do
bmi = calcBmi(
  request["weight"].to_f,
  request["height"].to_f
)
  erb :index, :locals => {:bmi => bmi}
end


def calcBmi(weight, height)
  return weight / (height * height)
end

