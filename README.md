# Tmdb::Movies

A gem for easy access to themoviedb.org's api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tmdb-movies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tmdb-movies

## Usage

TODO: Write usage instructions here

## Rate Limiter

TMDB api has a hard rate limit of 40 requests every 10 seconds, going over that limit very quickly gets you you a bunch of errors about exceeding the limit. The rate limit method is so you don't have to worry about your own code exceeding that limit as long as you only have a single thread running. I set a conservative rate limit of 2.5 requests a second as a default for when i would occasionally have more than 1 thread going at a time.

The rate_limit method can be overridden to better match your own application. When I started using multiple resque workers the default limiter wasn't enough. Below is my override for a multi thread limiter in rails using resque with many workers. Some jobs are completed very fast some are a little slower.

```ruby
#config/initializers/tmdb_rate_limit.rb


require "remote_lock" # the remote lock gem is not a requiremnt of tmdb-movies. Add it to your gem file to make use of this code

RemoteLock.class_eval do
  def acquire_lock(key, options = {})
    options = RemoteLock::DEFAULT_OPTIONS.merge(options)
    1.upto(options[:retries]) do |attempt|
      success = @adapter.store(key_for(key), options[:expiry])
      return if success
      break if attempt == options[:retries]
      Kernel.sleep(options[:initial_wait])
    end
    raise RemoteLock::Error, "Couldn't acquire lock for: #{key}"
  end
end

#this is to rate limit for multiple processes, this will be slower than the built in rate limiter for 1 process
Tmdb::Connection.class_eval do
  def rate_limit
    $lock.synchronize("tmdb-movies-rate-limiter", retries: 999) do
      last_time = Resque.redis.get("tmdb-movies-rate-limiter-last-update").to_f
      if Time.now.to_f<last_time+Tmdb::Connection::CONNECTION_SPACING
        sleep [last_time+Tmdb::Connection::CONNECTION_SPACING-Time.now.to_f,0].max #in case time passsed while processing
      end
      Resque.redis.set("tmdb-movies-rate-limiter-last-update", Time.now.to_f)
    end
    sleep 0.1 #if we don't sleep here the other proccesses don't get a chance to ask for a lock.
  end
end

$lock = RemoteLock.new(RemoteLock::Adapters::Redis.new(Resque.redis))
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/tmdb-movies/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
