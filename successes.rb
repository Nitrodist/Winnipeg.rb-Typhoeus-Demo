# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/net/http/rdoc/Net/HTTP.html
# https://github.com/dbalatero/typhoeus
# http://codesnippets.joyent.com/posts/show/868

require "net/http"
require "typhoeus"

# from http://www.skorks.com/2010/03/timing-ruby-code-it-is-easy-with-benchmark/
def time_method(method=nil, *args)
  beginning_time = Time.now
  if block_given?
    yield
  else
    self.send(method, args)
  end
  end_time = Time.now
  puts "\nTime elapsed #{(end_time - beginning_time)} seconds"
end

# use a server that won't mind 4000 requests in < 1 minute
# like the sintra server here -- ruby -rubygems server.rb
random_uri = URI('http://localhost:4567/with_random_delay')
no_random_uri = URI('http://localhost:4567/with_no_random_delay')
timeout = 5 # seconds
requests = 600


puts "Net::HTTP"

# net/http
time_method do
  requests.times do 
    request = Net::HTTP::Get.new(no_random_uri.path)
    http = Net::HTTP.new(no_random_uri.host, no_random_uri.port)
    http.read_timeout = timeout
    response = http.start do |web| 
      web.request(request)
    end
    if response.is_a?(Net::HTTPSuccess)
      print "."
    else
      print "#"
    end
  end
end 

puts "\n\nTyphoeus (like net/http)"

time_method do
  requests.times do 
    if Typhoeus::Request.get(no_random_uri.to_s).success?
      print "."
    else
      print "#"
    end
  end
end

puts "\n\nTyphoeus 1 thread"

time_method do
  hydra = Typhoeus::Hydra.new(:max_concurrency => 1)
  hydra.disable_memoization
  requests.times do
    request = Typhoeus::Request.new(no_random_uri.to_s, :timeout => timeout*1000)
    request.on_complete do |response|
      if response.success?
        print "."
      else
        print "#"
      end
    end
    hydra.queue(request)
  end

  hydra.run # this is a blocking call
end

puts "\n\nTyphoeus, up to 20 threads (no random delay)"
time_method do
  hydra = Typhoeus::Hydra.new(:max_concurrency => 20)
  hydra.disable_memoization
  requests.times do
    request = Typhoeus::Request.new(no_random_uri.to_s, :timeout => timeout*1000)
    request.on_complete do |response|
      if response.success?
        print "."
      else
        print "#"
      end
    end
    hydra.queue(request)
  end

  hydra.run # this is a blocking call
end

puts "\n\nTyphoeus, up to 20 threads (random delay)"
time_method do
  hydra = Typhoeus::Hydra.new(:max_concurrency => 20)
  hydra.disable_memoization
  requests.times do
    request = Typhoeus::Request.new(random_uri.to_s, :timeout => timeout*1000)
    request.on_complete do |response|
      if response.success?
        print "."
      else
        print "#"
      end
    end
    hydra.queue(request)
  end

  hydra.run # this is a blocking call
end
