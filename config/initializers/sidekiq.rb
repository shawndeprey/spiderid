if Rails.env.production?
	Sidekiq.configure_server do |config|
	  config.redis = { url: ENV["REDISCLOUD_URL"] }
	end unless ENV['REDISCLOUD_URL'].blank?

	Sidekiq.configure_client do |config|
	  config.redis = { url: ENV["REDISCLOUD_URL"] }
	end unless ENV['REDISCLOUD_URL'].blank?
end