if Rails.env.production?
	#uri = URI.parse(ENV["REDISCLOUD_URL"])
	uri = URI.parse("redis://rediscloud:r12wd84fdA192cys@pub-redis-19517.us-east-1-3.2.ec2.garantiadata.com:19517")
	$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end