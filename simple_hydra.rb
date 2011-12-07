require "typhoeus"

hydra = Typhoeus::Hydra.new
hydra.disable_memoization

url = "http://localhost:4567/with_no_random_delay"

3.times do
  hydra.queue(Typhoeus::Request.new(url,
                                    :method => :get,
                                    :timeout => 100))
end

hydra.run
