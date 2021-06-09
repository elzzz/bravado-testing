redis_conn = Proc.new {
  username = ENV['REDIS_USERNAME']
  password = ENV['REDIS_PASSWORD']
  host = ENV['REDIS_HOST'] || 'localhost'
  port = ENV['REDIS_PORT'] || 6379
  sidekiq_db = ENV['REDIS_SIDEKIQ_DB'] || 0

  Redis.new(username: username, password: password, host: host, port: port, db: sidekiq_db)
}


Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 12, &redis_conn)
end
