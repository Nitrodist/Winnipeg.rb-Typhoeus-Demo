require 'sinatra'

get '/with_random_delay' do
  if rand(5) == 0
    sleep(1.0) # sleep 333 ms
  else
    sleep(1.0/100.0) #sleep 10 ms
  end
  ""
end

get '/with_no_random_delay' do
  sleep(1.0/100.0) #sleep 10 ms
  ""
end
